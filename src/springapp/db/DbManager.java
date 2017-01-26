package springapp.db;


import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;

import com.mongodb.WriteResult;

import springapp.domain.Movies;
import springapp.domain.RankedMovies;
/**
 * 
 * Class to connect to MongoDB
 *
 */
public class DbManager {
	
	MongoOperations mongoOperation;
	
	
	private static DbManager instance;
	
	private DbManager(){
		configureDB();
	}
	
	public synchronized static DbManager getInstance(){
		
		if(instance==null){
			instance = new DbManager();
			
		}
		
		return instance;
	}
	private void configureDB(){
		ApplicationContext ctx =
	             new AnnotationConfigApplicationContext(SpringMongoConfig.class);
		mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
		
	}
	
	/**
	 * Get all the movies list
	 * @return
	 */
	public List<Movies> getMovies() {
		//changing for ranked movies
		List<RankedMovies> rankedMovieList = mongoOperation.findAll(RankedMovies.class);
		//sort the list according to rank
		List<Movies> movieList = Arrays.asList(rankedMovieList.get(0).getMovies());
		//movieList.sort(Comparator.comparing(Movies::getRanking));
		//Collections.reverse(movieList);
		return movieList;
	}
	/**
	 * Adds the movie to the database
	 * @param movei
	 * @return
	 */
	public boolean addMovie(Movies movie) {
		
		try {
			Query query = new Query();
			query.addCriteria(Criteria.where("_id").is("Ranks"));
			
			Update update = new Update();
			update.push("movies").atPosition(movie.getRanking()).each(movie);
			
			mongoOperation.updateFirst(query, update, RankedMovies.class);
		return true;
		}catch(Exception e){
			//catch if any exception
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * Adds the movie to the database
	 * @param movei
	 * @return
	 */
	public boolean updateMovie(Movies movie) {
		
		try {
		//Query query = new Query();
		//query.addCriteria(Criteria.where("name").is(movie.name));
		//Movies fetchedMovie = mongoOperation.findOne(query, Movies.class);
//		fetchedMovie.setName(movie.name);
//		fetchedMovie.setDirector(movie.director);
//		fetchedMovie.setRating(movie.rating);
//		fetchedMovie.setYear(movie.year);
//		fetchedMovie.setRanking(movie.ranking);
//		mongoOperation.save(fetchedMovie);
//		
		mongoOperation.updateMulti(Query.query(Criteria.where("_id").is("Ranks").andOperator(Criteria.where("movies._id").is(movie._id))),
			        new Update().set("movies.$",movie), RankedMovies.class);
		return true;
		}catch(Exception e){
			//catch if any exception
			e.printStackTrace();
			return false;
		}
	}
	/**
	 * Removes the movie from the database
	 * @param movie
	 * @return
	 */
	public boolean removeMovie(Movies movie) {
		try {
			//Construct a query to fetch the movie
			//Query query = new Query();
			
//			//query.addCriteria(Criteria.where("name").is(movie.name));
//			
//			Query query = new Query();
//			query.addCriteria(Criteria.where("_id").is("Ranks"));
//			
//			Update update = new Update();
//			
//			//update.pop("movies", Update.Position.valueOf(String.valueOf(movie.getRanking())));
//			//update.push("movies").atPosition(movie.getRanking()).each(movie);
//			update.pull("movies.name",movie.name);
//			WriteResult result = mongoOperation.upsert(query, update, RankedMovies.class);
			//what happens if there are multiple movies with same name
			mongoOperation.updateMulti(new Query(),
			        new Update().pull("movies", Query.query(Criteria.where("_id").is(movie._id))), RankedMovies.class);
			
			return true;
			}catch(Exception e){
				//catch if any exception
				e.printStackTrace();
				return false;
			}
	}

}
