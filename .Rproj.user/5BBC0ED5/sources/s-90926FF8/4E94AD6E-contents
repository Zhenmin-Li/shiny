.PHONY: shinyapp
.PHONY: clean

clean:
	rm derived_data/*.csv

derived_data/sentiment_afinn_ran.csv: project_cleaned.R\
 ./source_data/tweets_total.csv
	Rscript project_cleaned.R 

shinyapp: derived_data/sentiment_afinn_ran.csv
	Rscript shinyapp.R ${PORT}

shiny: derived_data/sentiment_afinn_ran.csv
	Rscript shiny.R ${PORT}