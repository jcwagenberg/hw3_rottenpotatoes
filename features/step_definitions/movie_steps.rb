# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  
  assert movies_table.hashes.count == Movie.all.count
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #print page.html
  movie_titles = page.all(:xpath, '//table/tbody/tr/td[1]/text()').map {|title| title.text}
  index_e1 = movie_titles.index(e1).to_i  
  index_e2 = movie_titles.index(e2).to_i
  
  assert index_e1 != 0 and index_e2 != 0 and index_e1 < index_e2
end


# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
    rating_list.split(",").each do |rating| 
      step %Q{I #{uncheck}check "ratings_#{rating.strip}"}
    end
      
end


#Then /I should( not)? see all of the movies: (.*)/ do |ifnot, movies_list|
Then /I should( not)? see all of the movies/ do |all_or_none|
  movies = page.all(:xpath, '//table/tbody/tr/td[1]/text()').map {|movie| movie.text}
  
  if all_or_none == " not"
    assert movies.count == 0
  else
    assert movies.count == Movie.all.count
  end
end

Then /^I should see the following ratings: (.*)/ do |rating_list|
    movie_ratings = page.all(:xpath, '//table/tbody/tr/td[2]/text()').map {|rating| rating.text}
    rating_list.split(",").each {|rating| assert movie_ratings.include?(rating.strip)}
end