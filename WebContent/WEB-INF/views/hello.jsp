<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>My Movie Manager</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<link rel="stylesheet" href="main.css" />
<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.13/css/jquery.dataTables.css">

  

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.13/js/jquery.dataTables.js"></script>



</head>
<body>

 <h1>Welcome to My movie manager</h1>
    <h3>My ranking of movies</h3>
    <input type="button" value="Add a new movie" id="addbtn" />
    <input type="button" value="Select and remove a movie" id="delbtn" />
    <input type="button" value="Select and Edit" id="updatebtn" />
    <br><br>
    <table id="table_id" class="display">
    <thead>	
        <tr>
        	<th>My Ranking</th>
            <th>Name</th>
            <th>Year</th>
            <th>Rating</th>
            <th>Director</th>
            
        </tr>
    </thead>
    <tbody>
    	<c:forEach items="${movieslist}" var="movie">
        <tr>
        	<td>${movie.ranking}</td>
            <td>${movie.name}</td>
            <td>${movie.year}</td>
            <td>${movie.rating}</td>
            <td>${movie.director}</td>
        </tr>
       
        </c:forEach>
    </tbody>
</table>


<!--Add Movie Form -->
<div id="addmoviediv">
<form class="form" action="#" id="addmovie">

<h3>Add new Movie</h3>
<hr/><br/>
<label>Name: <span>*</span></label>
<br/>
<input type="text" id="name" placeholder="Name"/><br/>
<br/>
<label>Year: <span>*</span></label>
<br/>
<input type="text" id="year" placeholder="Year"/><br/>
<br/>
<label>Director: <span>*</span></label>
<br/>
<input type="text" id="director" placeholder="director"/><br/>
<br/>
<label>Rating: <span>*</span></label>
<br/>
<input type="text" id="rating" placeholder="rating"/><br/>
<br/>
<label>Ranking: <span>*</span></label>
<br/>
<input type="text" id="ranking" placeholder="ranking"/><br/>
<br/>
<input type="button" id="send" value="Send"/>
<input type="button" id="cancel" value="cancel"/>

<br/>
</form>
</div>

</body>
<script>
var update = false; // global variable to indicate whether the request is for update or add
$(document).ready( function () {
    var table = $('#table_id').DataTable();
    $('#addbtn').click(addrow);
    $('#delbtn').click(delrow);
    $('#updatebtn').click(updaterow);
     
    
    table.on( 'click', 'tr', function () {
        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
        }
        else {
            table.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
    } );
    
   
} );

//Handle cancel button click event

$("#cancel").click(function() {
	location.reload();
})

//Contact form popup send-button click event.
$("#send").click(function() {
var name = $("#name").val();
var year = $("#year").val();
var director = $("#director").val();
var rating = $("#rating").val();
var ranking = $("#ranking").val();

if (name == "" || year == "" || director == "" || rating == "" || ranking == ""){
alert("Please Fill All Fields");
}else{


    
var moviedata = { 
	       moviename : name,
	       movieyear : year,
	       moviedirector : director,
	       movierating : rating,
	       movieranking : ranking
	}
$("#addmoviediv").css("display", "none");
if(update){

$('#table_id').dataTable().fnUpdate( [
                                      ranking,
                             		 name,
                             	    year,
                             	    rating,
                             	    director
	                            	    ] );
	
$.ajax({
    type: "POST",
    url: "/springapp/movies/updatemovie.htm",
    data: moviedata,
    success: function (result) {
        // do something.
    },
    error: function (result) {
        // do something.
    }
});
update =false;
}else {
	
	
	
	$('#table_id').dataTable().fnAddData( [
		 ranking,
		 name,
	    year,
	    rating,
	    director
	    ] );
	
	$.ajax({
    type: "POST",
    url: "/springapp/movies/addmovie.htm",
    data: moviedata,
    success: function (result) {
        // do something.
    },
    error: function (result) {
        // do something.
    }
});

} 

}
});
// adds a row
function addrow() {
   // $('#table_id').dataTable().fnAddData( [
    //   " ",
      //  " "
     //   ] );
    
	  //$.ajax({
        //    type: "POST",
        //    url: "addmovie",
        //    data: loginData,
        //    success: function (result) {
          //      // do something.
         //   },
        //    error: function (result) {
                // do something.
          //  }
      //  });
	 
	$("#addmoviediv").css("display", "block");


}

function updaterow() {
	 //get the date from table row and assign it to the contact form
	 
	var data = $('#table_id').DataTable().row('.selected').data();
	$("#name").val(data[1]);
	$("#year").val(data[2]);
	$("#director").val(data[4]);
	$("#rating").val(data[3]);
	$("#ranking").val(data[0]);
	update = true ; //making the update flag true since we want to update an entry
	$("#addmoviediv").css("display", "block");
}

function delrow() {
	var row = $('#table_id').DataTable().row('.selected');
	
	var data = row.data();
	var name = data[1];
	
	var moviedata = {
			moviename : name
	}
	//data[0];
	row.remove().draw( false );
	$.ajax({
	    type: "POST",
	    url: "/springapp/movies/deletemovie.htm",
	    data: moviedata,
	    success: function (result) {
	        // do something.
	    },
	    error: function (result) {
	        // do something.
	    }
	});
}

</script>
</html>