json:
	for bridge in Caltrans*/; do \
		cd $$bridge && make cache ; \
	done


.cache/models/mk[0-9].json:

sam.json:
	for i in Caltrans.*/; do cd $$i && make sam.json ; cd .. ; done

a:
	for i in Caltrans.*/; do echo $$i cd $$i && make ; cd .. ; done


