package springapp.controller;

import java.util.Collections;
import java.util.List;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import springapp.db.DbManager;
import springapp.domain.Movies;
/**
 * Basic hello controller
 * @author I054564
 *
 */
@Controller
@RequestMapping("/movies")
public class MovieController{
	
	protected final Log logger = LogFactory.getLog(getClass());

	@RequestMapping(method = RequestMethod.GET)
	public String getMovies(Model model) {
		// TODO Auto-generated method stub
		logger.info("returning hello view");
		List<Movies> moviesList = DbManager.getInstance().getMovies();
		
		model.addAttribute("movieslist", moviesList);
		return "hello";
	}
	
	@RequestMapping(value="/addmovie", method =RequestMethod.POST)
	@ResponseBody
	public ModelAndView addMovie(@RequestParam("moviename") String name, @RequestParam("movieyear") String year , @RequestParam("moviedirector") String
			director, @RequestParam("movierating") float rating , @RequestParam("movieranking") int ranking){
		Movies movies = new Movies();
		movies.setName(name);
		movies.setYear(year);
		movies.setDirector(director);
		movies.setRating(rating);
		movies.setRanking(ranking);
		DbManager.getInstance().addMovie(movies);
		return new ModelAndView("hello.jsp");
	}
	
	@RequestMapping(value="/deletemovie", method =RequestMethod.POST)
	public ModelAndView deleteMovie(@RequestParam("moviename") String name){
		Movies movies = new Movies();
		movies.setName(name);
		DbManager.getInstance().removeMovie(movies);
		return new ModelAndView("hello.jsp");
	}
	
	@RequestMapping(value="/updatemovie", method =RequestMethod.POST)
	public ModelAndView updateMovie(@RequestParam("moviename") String name,@RequestParam("movieyear") String year , @RequestParam("moviedirector") String
			director, @RequestParam("movierating") float rating , @RequestParam("movieranking") int ranking){
		Movies movies = new Movies();
		movies.setName(name);
		movies.setYear(year);
		movies.setDirector(director);
		movies.setRating(rating);
		movies.setRanking(ranking);
		DbManager.getInstance().updateMovie(movies);
		return new ModelAndView("hello.jsp");
	}

}
