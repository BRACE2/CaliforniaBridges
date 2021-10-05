--[[
cite-prgm – convert raw LaTeX page breaks to other formats
Copyright © 2021 Claudio Perez
Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.
THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
]]
local function cite_prgm(elem)
  io.stderr:write(pandoc.utils.stringify(elem)) 
  if elem.attributes['citeprgm'] then
    if FORMAT:match 'tex' then
      io.stdout:write(elem.attributes['citeprgm'])
      paper_citation = pandoc.Citation(elem.attributes['citeprgm'], 'NormalCitation')
      cite_paper = pandoc.Cite(elem.content,pandoc.List({paper_citation}))
      --cite_paper.citations = pandoc.List({paper_citation})

      command = '\\citeprgm{' .. pandoc.utils.stringify(elem) .. '}'
      resource = pandoc.RawInline('latex', command)
      return {resource, cite_paper}
    elseif FORMAT:match 'html' then
      return elem
    else 
      return elem
    end
  end
end

return {
  {Link = cite_prgm},
}
