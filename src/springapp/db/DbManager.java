package springapp.db;


import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

import com.mongodb.WriteResult;

import springapp.domain.Movies;
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
		List<Movies> movieList = mongoOperation.findAll(Movies.class);
		return movieList;
	}
	/**
	 * Adds the movie to the database
	 * @param movei
	 * @return
	 */
	public boolean addMovie(Movies movie) {
		
		try {
		mongoOperation.insert(movie);
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
			Query query = new Query();
			query.addCriteria(Criteria.where("name").is(movie.name));
			
			WriteResult result = mongoOperation.remove(query,Movies.class);
			
			
			return true;
			}catch(Exception e){
				//catch if any exception
				e.printStackTrace();
				return false;
			}
	}

}
