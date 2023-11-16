# Documentation Website

This document contains the information for working with the documentation website.

## Pre Requisites

Download and install the version of hugo for your system from [hugo's github releases](https://github.com/gohugoio/hugo/releases).

## Run the docs website locally

Hugo includes a development server with hot reloading so can view your changes as you make them. From the root of the project, run `make docs` to serve the website on your local machine.

## Structure

There are four folders that you will likely work with

### content

This is the folder contains the actual documentation markdown. This is where you will add new pages and edit existing pages. This is the folder that will probably get edited the most.

### layouts

This folder contains the html templates for the website. This is where you will edit the look and feel of the website. Since we are using a pre-made theme, html files for this folder are pulled from the theme's layout folder. If we want to override one of the pages in the theme, we can make a copy of the file and put it in this folder.

### static

This is where we can put images or other files that we want to include in the page
