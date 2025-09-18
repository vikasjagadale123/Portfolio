use netflix;

show tables;
select * from  netflix_titles_cleaned_final;

#1. How many total shows are there?
select count(*) as total from netflix_titles_cleaned_final;

#2. How many movies and TV shows separately? `if keyword and column name is same` 

select `type` , count(*) as movies_count
from netflix_titles_cleaned_final 
 group by `type`;


#3. What are the top 10 countries producing the most content?

select country, count(*) as total_count 
from netflix_titles_cleaned_final 
group by country
order by total_count desc
limit 10;


# 4. Which year had the highest number of releases?
select release_year, count(*)as highest_release
 from netflix_titles_cleaned_final 
group by release_year
order by highest_release desc
limit 2;

#5. Find the most common rating on Netflix.
SELECT rating , count(*) as highest_rating 
from netflix_titles_cleaned_final 
group by rating
order by highest_rating  desc
limit 1;

#6.Find all shows added in the year 2020.

select * from netflix_titles_cleaned_final 
where release_year="2020";

#7. Find the longest movie duration.

SELECT title, duration 
FROM netflix_titles_cleaned_final
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration, ' min', '') AS UNSIGNED) DESC
LIMIT 1;


#8Find all movies released before the year 2000.
SELECT title, release_year
FROM netflix_titles_cleaned_final
WHERE type = 'Movie' AND release_year < 2000;

#F9ind all shows that feature "Salman Khan" in the cast.

SELECT title, release_year
FROM netflix_titles_cleaned_final
where  cast like  '%Salman Khan%' ;


#9 Find the newest show added on Netflix.
SELECT title, type, date_added
FROM  netflix_titles_cleaned_final
ORDER BY STR_TO_DATE(date_added, '%M %d, %Y') DESC
LIMIT 1;

#10 Find the distribution of content by year and type.
SELECT release_year, type, COUNT(*) AS total
FROM netflix_titles
GROUP BY release_year, type
ORDER BY release_year DESC, total DESC;