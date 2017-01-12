package springapp.controller;

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
	
//	@RequestMapping(value="/addmovie")
//	@ResponseBody
//	public ModelAndView addMovie(){
//		return new ModelAndView("hello.jsp");
//	}

}
