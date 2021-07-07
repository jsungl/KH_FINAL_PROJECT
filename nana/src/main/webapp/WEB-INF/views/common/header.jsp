<%@page import="java.util.ArrayList"%>
<%@page import="com.kh.nana.place.model.vo.Place"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.kh.nana.place.model.vo.Place"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> <!-- form태그 -->
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>	<!-- security태그 -->
	 	     
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>${param.title}</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<!-- bootstrap js: jquery load 이후에 작성할것.-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">

<!-- 이모티콘 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.css"/> 
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
<!-- 아이콘 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/chat.css" />

<!-- 
    ellipsify jquery 라이브러리 (말줄임 기능) 
    https://github.com/ethagnawl/ellipsify
-->
<script src="${pageContext.request.contextPath}/resources/js/jquery.ellipsify.js"></script>


<!-- include summernote css/js -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<!-- include summernote-ko-KR -->
<script src="${pageContext.request.contextPath}/resources/js/summernote/lang/summernote-ko-KR.js"></script>

<!-- jquery ui 자동완성 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script>

/* javascript의 SimpleDateFormat같은 라이브러리 */
//출처 : https://stackoverflow.com/questions/4673527/converting-milliseconds-to-a-date-jquery-javascript
//*** This code is copyright 2002-2016 by Gavin Kistner, !@phrogz.net
//*** It is covered under the license viewable at http://phrogz.net/JS/_ReuseLicense.txt
Date.prototype.customFormat = function(formatString){
  var YYYY,YY,MMMM,MMM,MM,M,DDDD,DDD,DD,D,hhhh,hhh,hh,h,mm,m,ss,s,ampm,AMPM,dMod,th;
  YY = ((YYYY=this.getFullYear())+"").slice(-2);
  MM = (M=this.getMonth()+1)<10?('0'+M):M;
  MMM = (MMMM=["January","February","March","April","May","June","July","August","September","October","November","December"][M-1]).substring(0,3);
  DD = (D=this.getDate())<10?('0'+D):D;
  DDD = (DDDD=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][this.getDay()]).substring(0,3);
  th=(D>=10&&D<=20)?'th':((dMod=D%10)==1)?'st':(dMod==2)?'nd':(dMod==3)?'rd':'th';
  formatString = formatString.replace("#YYYY#",YYYY).replace("#YY#",YY).replace("#MMMM#",MMMM).replace("#MMM#",MMM).replace("#MM#",MM).replace("#M#",M).replace("#DDDD#",DDDD).replace("#DDD#",DDD).replace("#DD#",DD).replace("#D#",D).replace("#th#",th);
  h=(hhh=this.getHours());
  if (h==0) h=24;
  if (h>12) h-=12;
  hh = h<10?('0'+h):h;
  hhhh = hhh<10?('0'+hhh):hhh;
  AMPM=(ampm=hhh<12?'am':'pm').toUpperCase();
  mm=(m=this.getMinutes())<10?('0'+m):m;
  ss=(s=this.getSeconds())<10?('0'+s):s;
  return formatString.replace("#hhhh#",hhhh).replace("#hhh#",hhh).replace("#hh#",hh).replace("#h#",h).replace("#mm#",mm).replace("#m#",m).replace("#ss#",ss).replace("#s#",s).replace("#ampm#",ampm).replace("#AMPM#",AMPM);
};

$(function() {
	var previousScroll = 20;
    // scroll functions
    $(window).scroll(function(e) {
    
        // add/remove class to navbar when scrolling to hide/show
        var scroll = $(window).scrollTop();
        if (scroll >= previousScroll) {
        	$('.header-wrapper').addClass("header-hide");
       
        }else if (scroll < previousScroll) {
        	$('.header-wrapper').removeClass("header-hide");
            
        }
        previousScroll = scroll;
    
    });

	$("#loading").hide();

});



</script>

<%-- RedirectAttributes.addFlashAttribute의 저장된 속성값 사용(1회용) --%>
<c:if test="${not empty failLogin}">
<script>
alert("${failLogin}");
</script>
</c:if>
 
</head>
<body>
<div id="container">

	<header>

		<div class="header-wrapper">
		   <nav class="navbar navbar-expand-lg navbar-light" style="padding-top: 0;">
	           <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent">
	             <span class="navbar-toggler-icon"></span>
	           </button>
	           
	           <a class="navbar-brand mx-auto" href="${pageContext.request.contextPath}/">
	               <%-- <h1 style="margin:0">${param.title}</h1> --%>
	               <img src="${pageContext.request.contextPath}/resources/images/NANA.png" alt="로고이미지" style="height:70px;"/>
	           </a>
            

            
	           <div class="collapse navbar-collapse" id="navbarSupportedContent">
	               
	               
	               <ul class="navbar-nav ml-auto">
	                   
	                   <li class="nav-item dropdown">
	                       <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	                       지역
	                       </a>
	                       <div class="dropdown-menu alert-warning" aria-labelledby="navbarDropdown">
	                       <a class="dropdown-item" href="${pageContext.request.contextPath}/place/localDetail.do?localCode=L1">서울</a>
	                       <a class="dropdown-item" href="${pageContext.request.contextPath}/place/localDetail.do?localCode=L4">경기도</a>
	                       <a class="dropdown-item" href="${pageContext.request.contextPath}/place/localDetail.do?localCode=L2">충청도</a>
	                       <a class="dropdown-item" href="${pageContext.request.contextPath}/place/localDetail.do?localCode=L5">강원도</a>
	                       <a class="dropdown-item" href="${pageContext.request.contextPath}/place/localDetail.do?localCode=L3">전라도</a>
	                       <a class="dropdown-item" href="${pageContext.request.contextPath}/place/localDetail.do?localCode=L6">제주도</a>
	                       <a class="dropdown-item" href="${pageContext.request.contextPath}/place/localDetail.do?localCode=L7">경상도</a>
	                       </div>
	                   </li>
	
	                   <li class="nav-item">
	                       <a class="nav-link" href="${pageContext.request.contextPath}/board/boardList.do">커뮤니티</a>
	                   </li>
	
	                   
	               </ul>
	           	   <sec:authorize access="isAnonymous()">
	               <ul class="navbar-nav">
	                   <li class="nav-item">
	                       <button type="button" class="btn btn-outline-warning btn-sm" id="loginBtn" onclick="location.href='${pageContext.request.contextPath}/member/memberLogin.do';">
	                       로그인
	                       </button>
	                       <!-- <button type="button" class="btn btn-primary btn-sm" id="joinBtn">회원가입</button> -->

	                       <button type="button" class="btn btn-info btn-sm" id="joinBtn" onclick="location.href='${pageContext.request.contextPath}/member/memberEnroll.do';">

	                       회원가입
	                       </button>
	                   </li>
	               </ul>
	               </sec:authorize>
	               
	               <sec:authorize access="isAuthenticated()">
	               		<%-- 알림 내역 확인 창 --%>
							<a href="${pageContext.request.contextPath}/noti/myNoti.do" class="alarm p-3">
								<i class="fas fa-bell fa-2x"></i>
							</a>
						<%--------------------%>
		                <ul class="navbar-nav">
		                   <li class="nav-item dropdown">      
						    <a class="nav-link dropdown-toggle" href="#" id="profileDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							   <%-- <sec:authentication property="principal.username"/>님 --%>
							   <i class="fa fa-user-circle fa-2x"></i>
							</a>
						    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="profileDropdown">
      						  <a class="dropdown-item disabled" href="#">
      						  	<sec:authentication property="principal.name"/>님
      						  </a>
						      <div class="dropdown-divider"></div>
      						  <sec:authorize access="hasRole('ROLE_ADMIN')">
						      <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/adminManagement.do">관리자페이지</a>
						      </sec:authorize>
						      <sec:authorize access="!hasRole('ROLE_ADMIN') and hasRole('ROLE_USER')">
						      <a class="dropdown-item" href="${pageContext.request.contextPath}/mypage/mypage.do">마이페이지</a>
						      </sec:authorize>
						      <a class="dropdown-item" href="javascript:document.logoutForm.submit();">로그아웃</a>
						    </div> 
						   </li>
		               </ul>
				   </sec:authorize>
	               <form:form name="logoutForm" action="${pageContext.request.contextPath}/member/memberLogout.do" method="POST">
	               	<input type="hidden" name="some_key1" value="some_value1" />
				   </form:form>
	               
			       
	                   
	           </div>
            
        </nav>
        
        <div class="container mb-3">
            <%-- <form action="${pageContext.request.contextPath}/search/keyword.do">
              	<input type="hidden" name="sort" value="like-count"> --%>
            <form action="${pageContext.request.contextPath}/search/keyword.do">
                <input type="hidden" name="sort" value="place-name">
            <div class="input-group">
              <input class="form-control" name="searchKeyword" type="text" placeholder="Search" aria-label="Search" data-toggle="dropdown" style="color: #256d69">
              <div class="input-group-append">
                <button class="btn btn-warning" type="submit">
                <i class="bi bi-search"></i>
                </button>
              </div>
              <ul class="dropdown-menu" role="menu" aria-labelledby="search-rank" style="width: 100%;">
                <h3 style="color: #ce8832">인기 검색어</h3>
                <%	List<String> top5Keyword = (List<String>) session.getAttribute("top5Keyword");
                	if(top5Keyword != null){
                	for(int i = 0; i < top5Keyword.size();  i++){
                %>
	                <li style="color: #d39e34" role="presentation" style="margin-bottom: 10px;">
	                    <span class="num"><%= i+1 %>.</span>
	                    <a style="color: #f6bd3a" role="menuitem" tabindex="-1" href="${pageContext.request.contextPath}/search/keyword.do?sort=place-name&searchKeyword=<%= top5Keyword.get(i) %>"><%= top5Keyword.get(i) %></a>
	                </li>
	            <% } } %>
              </ul>
            </div>
            </form>
        </div>

	</header>

	<!-- Modal 자리-->
	
	

	
	<section id="content">
	<c:if test="${not empty msg}">
		<div class="alert alert-warning alert-dismissible fade show" role="alert">
		  <strong>${msg}</strong>
		  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
		    <span aria-hidden="true">&times;</span>
		  </button>
		</div>
	</c:if>
		