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
            <th>Name</th>
            <th>Year</th>
            <th>Rating</th>
            <th>Director</th>
            <th>Id</th>
            <th>IMDB Url</th>
            <th>Comments </th>
            
        </tr>
    </thead>
    <tbody>
    	<c:forEach items="${movieslist}" var="movie">
        <tr>
            <td>${movie.name}</td>
            <td>${movie.year}</td>
            <td>${movie.rating}</td>
            <td>${movie.director}</td>
            <td>${movie.id}</td>
            <td>${movie.url}</td>
            <td><textarea name="" id="" cols="45" rows="2"></textarea> </td>
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
<label>IMDB Link: <span>*</span></label>
<br/>
<input type="text" id="url" placeholder="url"/><br/>
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
    var table = $('#table_id').DataTable({
    	 "order": [], //switch off the default sorting in data table
    	 //http://stackoverflow.com/questions/4964388/is-there-a-way-to-disable-initial-sorting-for-jquery-datatables
    	 "columnDefs": [
            {
                "targets": [ 4 ],
                "visible": false,
                "searchable": false
            },
            {
                "targets": [ 5 ],
                "visible": false,
                "searchable": false
            },
            {
            	 "render": function ( data, type, row ) {
                     return '<a href ="'+row[5]+'" target="_blank" >'+data+'</a>';
                 },
                 "targets": 0
            } 
            ]
    });
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
var url = $("#url").val();

if (name == "" || year == "" || director == "" || rating == "" || url == ""){ //commenting out rating for now
alert("Please Fill All Fields");
}else{


    
var moviedata = { 
	       moviename : name,
	       movieyear : year,
	       moviedirector : director,
	       movierating : rating,
	       movieranking : ranking,
	       movieurl : url
	}
$("#addmoviediv").css("display", "none");
if(update){
	
var index = $('#table_id').DataTable().row('.selected').index();
var id = $('#table_id').DataTable().row('.selected').data()[4];
$('#table_id').dataTable().fnUpdate( [
                             		 name,
                             	    year,
                             	    rating,
                             	    director,
                             	    id,
                             	    url
	                            	    ],index );

var movieupdatedata = { 
	       moviename : name,
	       movieyear : year,
	       moviedirector : director,
	       movierating : rating,
	       movieid : id,
	       movieurl : url
	}
$.ajax({
    type: "POST",
    url: "/springapp/movies/updatemovie.htm",
    data: movieupdatedata,
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

		 name,
	    year,
	    rating,
	    director,
	    " ",
	    url
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
	$("#name").val(data[0]);
	$("#year").val(data[1]);
	$("#director").val(data[3]);
	$("#rating").val(data[2]);
	//$("#ranking").val(data[0]);
	update = true ; //making the update flag true since we want to update an entry
	$("#addmoviediv").css("display", "block");
}

function delrow() {
	var row = $('#table_id').DataTable().row('.selected');
	
	var data = row.data();
	var id = data[4];
	
	var moviedata = {
			movieid : id
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