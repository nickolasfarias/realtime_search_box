# Realtime Search Box

Realtime Search Box is a Ruby on Rails application that allows users to search for movies and track their search queries. The application features two main views: a movie search view and a search data view.

## Features

1. **Movie Search View**
   - A search bar where users can input movie names to search for.
   - Displays search results in real-time as users type in the search bar.

2. **Search Data View**
   - Displays the most frequent searches made by the user.
   - Shows logs of all searches made by the user.
   - Initially presents search data tracked by the user's IP address.
   - Allows viewing search data tracked by other users' IP addresses.

## Controller Specifications

The application includes RSpec tests for the `SearchQueriesController`. The controller specs include:

### POST #create

- **When the query is empty:**
  - Ensures no new search query is created and returns no content.

- **When the query is not empty:**
  - Creates a new search query and removes incomplete queries.
  - Returns an error if the query cannot be saved.

### GET #index

- **When there are queries for the user IP:**
  - **Sets the last incomplete query to full:** Updates the last incomplete query to be marked as full.
  - **Retrieves queries related to the user IP:** Ensures the queries associated with the user's IP are fetched.
  - **Orders queries by created_at desc:** Verifies that queries are ordered by their creation date in descending order.
  - **Retrieves top 10 queries for the user IP:** Fetches the top 10 most frequent queries.

- **When there are no queries for the user IP:**
  - Returns an empty list.

### Private Methods

- **#user_deleted_query?**
  - Returns `true` if the query is empty.
  - Returns `false` if the query is not empty.

- **#remove_incomplete_queries**
  - **Removes incomplete queries except the last one:** Ensures that all incomplete queries except the last are removed.
  - **Removes all incomplete queries if last_query is not provided:** Deletes all incomplete queries if no specific last query is provided.

## Getting Started

### Prerequisites

- Ruby (version 2.7.0 or higher)
- Rails (version 6.0 or higher)
- PostgreSQL (or another database of your choice)

### Installation

1. **Clone the repository:**

   ```sh
   git clone https://github.com/nickolasfarias/realtime_search_box.git
   cd realtime_search_box

2. **Install dependencies:**

   ```sh
   bundle install

3. **Set up the database::**

   ```sh
   rails db:create
   rails db:migrate

4. **Seed the database:**

   ```sh
   rails db:seed

5. **Run the server:**

   ```sh
   rails server
