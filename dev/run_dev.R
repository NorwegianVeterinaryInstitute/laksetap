# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

# Change this to your preferred browser
#options(browser = "xdg-open")

# Comment this if you don't want the app to be served on a random port
options(shiny.port = httpuv::randomPort())

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# Data and colors
laksetap::load_data()
laksetap::make_palette()

# Run the application 
run_app()
