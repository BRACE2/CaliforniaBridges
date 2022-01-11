#!/bin/env -S ipython --
import numpy as np
from scipy.linalg import block_diag
NAME = "plot"

HELP = """
usage: {NAME} SAM.json
       {NAME} SAM.json RES.txt

"""

REQUIREMENTS = """
scipy
numpy
matplotlib.pyplot
"""

#----------------------------------------------------
# Data shaping / Misc.
#----------------------------------------------------
def wireframe(sam:dict)->dict:
    """
    return dict with the form:
        {<elem tag>: {"crd": [<coordinates>], ...}}
    """
    geom = sam["geometry"]
    trsfm = {t["name"]: t for t in sam["properties"]["crdTransformations"]}
    nodes = {n["name"]: n for n in geom["nodes"]}
    elems =  {
      e["name"]: dict(
        **e, 
        crd=np.array([nodes[n]["crd"] for n in e["nodes"]]),
        trsfm=trsfm[e["crdTransformation"]] if "crdTransformation" in e else None
      ) for e in geom["elements"]
    }
    return dict(nodes=nodes, elems=elems)

#----------------------------------------------------
# Kinematics
#----------------------------------------------------
# Helper functions for extracting rotations in planes
elev_dofs = lambda u: u[[1,2]]
plan_dofs = lambda u: u[[3,4]]

def elastic_curve(x, v, L, scale=1.0):
    "compute points along the elastica"
    vi, vj = v
    xi = x/L                        # local coordinates
    N1 = 1.-3*xi**2+2*xi**3
    N2 = L*(xi-2*xi**2+xi**3)
    N3 = 3.*xi**2-2*xi**3
    N4 = L*(xi**3-xi**2)
    y = np.array(vi*N2+vj*N4)*scale
    return y.flatten()

def local_deformations(u,L):
    "return local frame deformations"
    xi, yi, zi, si, ei, pi = range(6)
    xj, yj, zj, sj, ej, pj = range(6,12)
    elev_chord = (u[zj]-u[zi]) / L
    plan_chord = (u[yj]-u[yi]) / L
    return np.array([
        [u[xj] - u[xi]], # xi
        [u[ei] - elev_chord],  # vi_elev
        [u[ej] - elev_chord],  # vj_elev

        [u[pi] - plan_chord],
        [u[pj] - plan_chord],
        [u[sj] - u[si]],
    ])


def rotation(xyz:np.ndarray, vert=(0,0,-1))->np.ndarray:
    "Create a rotation matrix between local e and global E"
    dx = xyz[1] - xyz[0]
    L = np.linalg.norm(dx)
    e1 = dx/L
    v13 = np.atleast_1d(vert)
    v2 = -np.cross(e1,v13)
    e2 = v2 / np.linalg.norm(v2)
    v3 =  np.cross(e1,e2)
    e3 = v3 / np.linalg.norm(v3)
    return np.stack([e1,e2,e3])

def displaced_profile(
        xaxis: np.ndarray,
        coord: np.ndarray,
        displ: np.ndarray,
    )->np.ndarray:
    displ[:]

def displaced_profile(
        coord: np.ndarray,
        displ:np.ndarray,
        vect=None,
        scale:float = 1.0,
        glob:bool=True,
    )->np.ndarray:
    n = 40
    #          (---ndm---)
    rep = 4 if len(coord[0])==3 else 2
    Q = rotation(coord, vect)
    L = np.linalg.norm(coord[1] - coord[0])
    v = local_deformations(block_diag(*[Q]*rep)@displ, L)
    x = np.linspace(0.0, L, n)

    plan_curve = elastic_curve(x, plan_dofs(v), L, scale=scale)
    elev_curve = elastic_curve(x, elev_dofs(v), L, scale=scale)

    dy,dz = Q[1:,1:]@np.linspace(displ[1:3], displ[7:9], n).T
    local_curve = np.stack([x, plan_curve+dy, elev_curve+dz])


    if glob:
        global_curve = Q.T@local_curve + coord[0][None,:].T

    return global_curve



#----------------------------------------------------
# Plotting
#----------------------------------------------------
def new_3d_axis():
    import matplotlib.pyplot as plt
    _, ax = plt.subplots(1, 1, subplot_kw={"projection": "3d"})
    ax.set_autoscale_on(True)
    ax.set_axis_off()
    return ax

def set_axis(ax):
    # Make axes limits 
    aspect = [ub - lb for lb, ub in (getattr(ax, f'get_{a}lim')() for a in 'xyz')]
    aspect = [max(a,max(aspect)/8) for a in aspect]
    ax.set_box_aspect(aspect)

def plot(frame):
    props = {"frame": {"color": "grey", "alpha": 0.6}}
    ax = new_3d_axis()
    for e in frame["elems"].values():
        x,y,z = np.array(e["crd"]).T
        ax.plot(x,z,y, **props["frame"])
    return ax

def plot_director(nodes, res, ax=None):
    for n in nodes.values():
        ax.scatter()

def plot_displ(frame, res, scale=1.0, ax=None):
    props = {"color": "red"}
    for el in frame["elems"].values():
        if "zero" not in el["type"].lower():
            glob_displ = [
                u for n in el["nodes"] 
                #   extract displ from node, default to ndf zeros
                    for u in res.get(n,[0.0]*frame["nodes"][n]["ndf"])
            ]
            vect = el["trsfm"]["vecInLocXZPlane"]
            x,y,z = displaced_profile(el["crd"], glob_displ, scale=scale, vect=vect)
            ax.plot(x,z,y, **props)
    return ax

#----------------------------------------------------
# Script functions
#----------------------------------------------------
def parse_args(argv):
    opts = {
        "mode": 1,
        "sam_file":   None,
        "res_file":   None,
        "write_file": None
    }
    for arg in iter(argv[1:]):
        if arg == "--help":
            print(HELP) and exit(0)
        elif arg == "--install":
            pass
        elif arg[:2] == "-m":
            opts["mode"] = int(arg[2]) if len(arg) > 2 else int(next(arg))
        elif arg[:2] == "-o":
            opts["write_file"] = arg[2:] if len(arg) > 2 else next(arg)
        elif not opts["sam_file"]:
            opts["sam_file"] = arg
        else:
            opts["res_file"] = arg
    return opts

if __name__ == "__main__":
    import json,sys,yaml
    opts = parse_args(sys.argv)

    with open(opts["sam_file"], "r") as f:
        frm = wireframe(json.load(f)["StructuralAnalysisModel"])

    ax = plot(frm)
    if len(sys.argv) > 2:
        with open(opts["res_file"], "r") as f:
            res = yaml.load(f,Loader=yaml.Loader)[opts["mode"]]
        plot_displ(frm, res, ax=ax)

    set_axis(ax)

    import matplotlib.pyplot as plt
    plt.show()

