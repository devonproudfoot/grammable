# Grammable

## Running locally

To run the application locally, ensure that your computer has Ruby version 2.5.3.  Clone the repository by running `git clone https://github.com/devonproudfoot/grammable`.  Navigate to the folder on your computer and run `bundle install` to install all relevant gems and `rake db:migrate` to create the initial database.  Finally, run `rails server -b 0.0.0.0 -p 3000` and navigate to localhost:3030 in the web browser of your choice!

## Overview

Grammable is a web application similar to Instagram, allowing users to post photographs as well as comments.  Built on the Ruby on Rails framework, Grammable was built with Test Driven Design.

## Login

On the top navigation bar, select the option to either create an account, or sign into an existing account.  This will prompt for an email and a password, and will allow you to post pictures and leave comments on others.

![Login](/readme_images/login.png)

## Posting

Logging into the application will allow users to select the "New Post" option in the navigation bar.  A new page will open up with an option to browse on your computer to the image file to be uploaded, as well as write a message or caption to accompany the image.

![Posting](/readme_images/new_post.png)

## Commenting

Underneath each image are the comments.  A new comment can be added by filling in the text box and pressing the post button.

![Comment](/readme_images/comment.png)


