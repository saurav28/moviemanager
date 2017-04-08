package springapp.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document (collection="RankedMovies")
public class RankedMovies {
	
	@Id
	public String _id;
	public Movies[] movies;

	public String get_id() {
		return _id;
	}

	public void set_id(String _id) {
		this._id = _id;
	}

	public Movies[] getMovies() {
		return movies;
	}

	public void setMovies(Movies[] movies) {
		this.movies = movies;
	}
	
	

}
