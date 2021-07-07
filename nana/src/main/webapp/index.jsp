<%@page import="com.kh.nana.common.util.HelloSpringUtils"%>
<%@page import="com.kh.nana.place.model.vo.PlaceExt"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<%
	List<PlaceExt> mainPlaceList = (List<PlaceExt>) request.getAttribute("mainPlace");
	List<String> keywordCheck = (List<String>) session.getAttribute("keywordList");
	List<String> visitPlaceCheck = (List<String>) session.getAttribute("visitList");
	String appkey = HelloSpringUtils.getApiKey("apikeys.properties", "tmapKey");
%>
<style>
.chat_icon {
	position: fixed;
	right: 30px;
	bottom: 0px;
	font-size: 50px;
	color: #f6bd3a;
	text-decoration: none;
	cursor: pointer;
	z-index: 1000;
}

.chat_box {
	position: fixed;
	padding: 5px;
	right: 30px;
	bottom: 100px;
	width: 400px;
	/* height: 500px;
		background: #fff;
		border: 1px solid gray; */
	z-index: 1000;
	transition: all 0.3s ease-out;
	transform: scaleY(0);
}

.chat_box.active {
	transform: scaleY(1);
}

.main-slide .carousel-item {
	height: 400px;
}

.mainP, h3 {
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

a {
	color: black;
	text-decoration: none;
}

a:hover {
	color: black;
	text-decoration: none;
}

h2 {color : #f6bd3a }
</style>

<%-- content --%>
	<!-- 메인 슬라이드 -->
	<div class="main-slide">
	    <div class="col-xs-12">
	        <div id="main-carousel" class="carousel slide" data-ride="carousel">
	            <ol class="carousel-indicators">
	                <li data-target="#main-carousel" data-slide-to="0"
	                    class="active"></li>
	                <li data-target="#main-carousel" data-slide-to="1"></li>
	                <li data-target="#main-carousel" data-slide-to="2"></li>
	            </ol>
	            <div class="carousel-inner">
	             	<div class="carousel-item active">
		             	<a href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=<%= mainPlaceList.get(0).getPlaceNo() %>">
		                    <img class="d-block w-100 h-100" src="${pageContext.request.contextPath}/resources/upload/place/<%=mainPlaceList.get(0).getPhotoList().get(0).getRenamedFilename()%>">
		                    <div class="carousel-caption d-none d-md-block">
								<h3><%= mainPlaceList.get(0).getPlaceName() %></h3>
								<p class="mainP"><%= mainPlaceList.get(0).getContent() %></p>
							</div>
						</a>
	                </div>
	             	<div class="carousel-item">
	             		<a href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=<%= mainPlaceList.get(1).getPlaceNo() %>">
		                    <img class="d-block w-100 h-100" src="${pageContext.request.contextPath}/resources/upload/place/<%=mainPlaceList.get(1).getPhotoList().get(0).getRenamedFilename()%>">
		                    <div class="carousel-caption d-none d-md-block">
								<h3><%= mainPlaceList.get(1).getPlaceName() %></h3>
								<p class="mainP"><%= mainPlaceList.get(1).getContent() %></p>
							</div>
						</a>
	                </div>
	             	<div class="carousel-item">
	             		<a href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=<%= mainPlaceList.get(2).getPlaceNo() %>">
		                    <img class="d-block w-100 h-100" src="${pageContext.request.contextPath}/resources/upload/place/<%=mainPlaceList.get(2).getPhotoList().get(0).getRenamedFilename()%>" alt="First slide">
		                    <div class="carousel-caption d-none d-md-block">
								<h3><%= mainPlaceList.get(2).getPlaceName() %></h3>
								<p class="mainP"><%= mainPlaceList.get(2).getContent() %></p>
							</div>
						</a>
	                </div>
	             
	            </div>
	            <a class="carousel-control-prev" href="#main-carousel" role="button" data-slide="prev"> 
	                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	                <span class="sr-only">Previous</span>
	            </a> 
	            <a class="carousel-control-next" href="#main-carousel" role="button" data-slide="next">
	                <span class="carousel-control-next-icon" aria-hidden="true"></span>
	                <span class="sr-only">Next</span>
	            </a>
	        </div>
	    </div>
	</div>
	<br />
	<br />


	<!-- 최근 검색 (노출, 밀어내기)-->
	<c:if test="<%= keywordCheck != null %>">
	<div class="search-word container">
		<h2>최근 검색어</h2>
		<c:forEach items="${keywordList}" var="keyword" varStatus="vs">
			<div class="col-lg-2">
				<a style="color: #256d69" href="${pageContext.request.contextPath}/search/keyword.do?sort=place-name&searchKeyword=${keyword}">${keyword}</a>
			</div>
		</c:forEach>
	</div>
	<br />
	<br />
	</c:if>
	
	<!-- 최근본 장소(슬라이드) -->
	<c:if test="<%= visitPlaceCheck != null %>">
	<div class="container my-3">
		<h2>최근 본 장소</h2>
			<div class="row mx-auto my-auto">
				<div id="recipeCarousel" class="carousel slide w-100" data-ride="carousel" data-interval="false">
					<div class="carousel-inner recipe w-100 " role="listbox">
					
					</div>
				<a class="carousel-control-prev w-auto" href="#recipeCarousel" role="button" data-slide="prev">
					<span class="carousel-control-prev-icon bg-dark border border-dark rounded-circle" aria-hidden="true"></span>
					<span class="sr-only">Previous</span>
				</a>
				<a class="carousel-control-next w-auto" href="#recipeCarousel" role="button" data-slide="next">
					<span class="carousel-control-next-icon bg-dark border border-dark rounded-circle" aria-hidden="true"></span>
					<span class="sr-only">Next</span>
				</a>
			</div>
		</div>
	</div>
		
	<script>
	    $(function(){
	    	<c:forEach items="${visitPlaceList}" var="place" varStatus="vs">
	    	$('<div class="carousel-item recipe"><div class="col-md-4"><div class="card card-body"><a href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=${place.placeNo}"><img class="img-fluid" src="${pageContext.request.contextPath}/resources/upload/place/${place.photoList[0].renamedFilename}"><p style="color: #256d69">${place.placeName}</p></a></div></div></div>')
	    	.appendTo('.carousel-inner.recipe');
			</c:forEach> 
			$('.carousel-item.recipe').first().addClass('active');
	    }); 
		
        $('#recipeCarousel').carousel({
            //interval: 10000
        });

    	$(function(){
			var cnt = $('#recipeCarousel .carousel-item').length;
			$('#recipeCarousel .carousel-item').each(function(){
				var minPerSlide = 3;
				var next = $(this).next();
				if (!next.length) {
					next = $(this).siblings(':first');
				}
				next.children(':first-child').clone().appendTo($(this));
				
				 if(cnt >= 3){  
					for (var i=0;i<minPerSlide;i++) {
						next=next.next();
						if (!next.length) {
							next = $(this).siblings(':first');
						}
						next.children(':first-child').clone().appendTo($(this)); 
					}
				 } 
			});
    	});
	</script>
	<br />
	<br />
	</c:if>
	
	<div class="container" id="loading">
		<img src="${pageContext.request.contextPath}/resources/images/Spinner.gif" alt="loading"/>
	</div>

	<!-- 상세 검색(토글처리) -->
	<div class="accordion" id="detailSearch">
		<div class="card col-sm-10 col-md-8 col-lg-6" id="detailSrch">
		    <div class="card-header" id="headingOne" style="background-color:#fff;">
		      <h5 class="mb-0">
		        <button class="btn btn-link collapsed text-info btn-block" 
		        	type="button"
		        	id="detailOriginBtn" 
		        	data-toggle="collapse" 
		        	data-target="#collapseOne" 
		        	aria-expanded="false" 
		        	aria-controls="collapseOne" 
		        	style="text-decoration: none;font-size:1em;">
		        <i class="bi bi-sun"></i> 상세검색 <i class="bi bi-tree"></i>
		        </button>
		      </h5>
		    </div>
		
		    <div id="collapseOne" 
		    	class="collapse" 
		    	aria-labelledby="headingOne" 
		    	data-parent="#detailSearch">
		      <div class="card-body">
		        <form:form action="${pageContext.request.contextPath}/search/detailSearch.do"  name="detailSrchFrm" id="detailSrchFrm" method="post">				  
				  <div class="form-group">
				    <label for="startPlace" >출발지</label>
				    <select class="form-control" name="startPlace">
				      <option value="none" selected disabled>시/도</option>
				      <option value="126.97795030674587,37.56641997185025">서울</option>
				      <option value="127.00921155471205,37.27510283867694">경기</option>
				      <option value="127.72966265415353,37.88616626481959">강원</option>
				      <option value="127.4913874411985,36.635998684296354">충북</option>
				      <option value="126.67258145469026,36.66054765014719">충남</option>
				      <option value="127.10884108169533,35.82272472090261">전북</option>
				      <option value="126.46298856997258,34.81643878615371">전남</option>
				      <option value="128.50560632585095,36.57620161522925">경북</option>
				      <option value="128.69252674300503,35.23853584053257">경남</option>
				      <option value="126.53148501857918,33.502945804947494">제주</option>
				      <option value="126.70587814910647,37.456189771861496">인천</option>
				      <option value="127.38479723933385,36.350646783477266">대전</option>
				      <option value="127.28872188166561,36.48030441304464">세종</option>
				      <option value="126.84610949113916,35.19765572864909">광주</option>
				      <option value="129.31280881185938,35.55259573209192">울산</option>
				      <option value="128.6025278280445,35.874723704649355">대구</option>
				      <option value="129.0749783170378,35.17994169091095">부산</option>
				    </select>
				  </div>
				
				  <div class="form-group">
				    <label for="endPlace">도착지</label>
				    <select class="form-control" name="endPlace">
				      <option value="none" selected disabled>시/도</option>
				      <option value="L1">서울</option>
				      <option value="L4">경기도/인천</option>
				      <option value="L2">충청도/대전/세종</option>
				      <option value="L3">전라도/광주</option>
				      <option value="L5">강원도</option>
				      <option value="L6">제주도</option>
				      <option value="L7">경상도/부산/대구/울산</option>
				    </select>
				  </div>
				  
				  <div class="form-group">
				    <label for="timeCost">소요시간(내외)</label>
				    <select class="form-control" name="timeCost">
				      <option value="none" selected disabled>시간선택</option>
				      <option value="1">1시간</option>
				      <option value="2">2시간</option>
				      <option value="3">3시간</option>
				      <option value="4">4시간</option>
				      <option value="5">5시간</option>
				    </select>
				    <p class="mt-1" style="color:#666; font-size: 12px;">※차량 이동 기준 예상시간이므로 실제 소요시간은 다를 수 있습니다</p> 
				  </div>
				  
				  <div class="form-group">
				    <label for="categorys">카테고리</label>
				    <div class="text-center">					
						  <div class="form-check form-check-inline">
						  	<input class="form-check-input" type="checkbox" name="category" id="c1" value="C1">
						  	<label class="form-check-label" for="c1">랜드마크</label>
						  </div>
						  <div class="form-check form-check-inline">
						  	<input class="form-check-input" type="checkbox" name="category" id="c2" value="C2">
						  	<label class="form-check-label" for="c2">맛집</label>
						  </div>
						  <div class="form-check form-check-inline">
						  	<input class="form-check-input" type="checkbox" name="category" id="c3" value="C3">
						  	<label class="form-check-label" for="c3">오락</label>
						  </div>
						  <div class="form-check form-check-inline">
						  	<input class="form-check-input" type="checkbox" name="category" id="c4" value="C4">
						  	<label class="form-check-label" for="c4">레저/스포츠</label>
						  </div>
						  <div class="form-check form-check-inline">
						  	<input class="form-check-input" type="checkbox" name="category" id="c5" value="C5">
						  	<label class="form-check-label" for="c5">캠핑/차박</label>
						  </div>
					</div>
				  </div>
				  
				  <div class="form-group">
				  	  <label for="date">예정일자</label>
				  	  <input type="date" name="dueDate" id="dueDate">
				  </div>
				  
				  <div class="form-group">
					  <label>동반유형</label>
					  <div class="text-center">
						  <div class="form-check form-check-inline text-center">
						  	<input class="form-check-input" type="checkbox" name="pet" value="0">
						  	<label class="form-check-label" for="pet">반려동물 동반</label>
						  </div>
					  </div>
				  </div>
				  <div class="mx-auto text-center">
				  	<button type="submit" id="detailSearchBtn" class="btn btn-info btn-lg" style="width:40%;">상세검색</button>
				  	<button type="reset" id="resetBtn" class="btn btn-secondary btn-lg" style="width:40%;">초기화</button>
				  </div>
				  
				  <input type="hidden" id="tmapKey" value="<%=appkey%>" />
				  <input type="hidden" name="detailSrchPlaceNo[]" class="detailSrchplaceNo"/>
				  <input type="hidden" name="sort" value="place-name">
				  <input type="hidden" name="selectedStartPlace">
				</form:form>
		      </div>
		    </div>
	  	</div>
	</div>
	
	<script>

		$("#detailOriginBtn").click(e => {
			$("#detailSrchFrm")[0].reset();
		});
		
		// 예정일자 기본값 = 당일
		document.getElementById('dueDate').valueAsDate = new Date();

		//검색버튼 ajax
		$("#detailSrchFrm").submit(e => {
			e.preventDefault();
			
			if($("select[name=startPlace]").val() == null){
				alert("출발지를 선택해주세요");
				return false;
			}

			if($("select[name=endPlace]").val() == null){
				alert("도착지를 선택해주세요");
				return false;
			}

			if($("select[name=timeCost]").val() == null){
				alert("소요시간을 선택해주세요");
				return false;
			}

			if($("input[name=category]:checked").length == 0) {
				alert("카테고리를 1개이상 선택해주세요");
				return false;
			}		

			$("#loading").show();
				
			const startPlace = $("select[name=startPlace]").val(); 
			const timeCost = $("select[name=timeCost]").val(); 

			const startPlaceX = startPlace.split(',')[0]; //출발지x좌표
			const startPlaceY = startPlace.split(',')[1]; //출발지y좌표
			
			var selectTime = $("select[name=timeCost]").val(); //소요시간
			var tDistance;
			var tTime;
			var i = 0;
			

			const endplace = $("select[name=endPlace]").val();
			const categoryArr = [];
			const withPet = $("input[name=pet]:checked").length;
			if(withPet == 1){
				$("input[name=pet]").val(1);
			}
			
			$("input[name=category]:checked").each(function(e){
				var value = $(this).val();
				categoryArr.push(value);
			});
	
			console.log("endplace = " + endplace);
			console.log("categoryArr = " + categoryArr);
			console.log("withPet = " + withPet);

			var searchList = [];
			var searchListLen = 0;	
			$.ajax({
				url: "${pageContext.request.contextPath}/search/detailSearch1.do",
				data: {endplace,categoryArr,withPet},
				async:false,
				success: (data) => {
					const {result} = data;
					const {list} = data;
					if(result){				
						//console.log(list.length);						
						searchList = list;			
					}else{
						alert("검색오류");
						return false;
					}
				},
				error: console.log
			});

			var detailSrchPlaceArr = [];
			//console.log("확인용 = " + searchList.length);	
			//console.log("tmap key = " + $("#tmapKey").val());

			if(searchList.length == 0){
				e.target.submit();
				e.target.reset();
			}else {
			
				let timerId = setInterval(function() {
					 var appkey = $("#tmapKey").val();
					 //var endplaceX = $(".placeX" + i).val();
					 var endplaceX = searchList[i].xcoord;
					 console.log("endplaceX : " + endplaceX);
					 //var endplaceY = $(".placeY" + i).val();
					 var endplaceY = searchList[i].ycoord;
					 console.log("endplaceY : " + endplaceY);
					 
					$.ajax({
							type : "POST",
							url : "https://apis.openapi.sk.com/tmap/routes?version=1&format=json&callback=result",
							async : false,
							data : {
								"appKey" : appkey,
								"startX" : startPlaceX,
								"startY" : startPlaceY,
								"endX" : endplaceX,
								"endY" : endplaceY,
								"reqCoordType" : "WGS84GEO",
								"resCoordType" : "EPSG3857",
								"searchOption": "0",
						        "trafficInfo": "N"						
							},
							success : function(response) {
								var resultData = response.features;
	
								tDistance = "총 거리 : " + (resultData[0].properties.totalDistance / 1000).toFixed(1) + "km,";
								//console.log(tDistance);
								tTime = "총 시간 : " + (resultData[0].properties.totalTime / 60).toFixed(0) + "분";
								console.log(tTime);
								tTime = (resultData[0].properties.totalTime / 60).toFixed(0);
							},
							error(xhr,status,err){
				  			  console.log(xhr,status,err);
				  			  return false;
				  		  	},
				  		  	complete() {
				  		  		if(tTime < selectTime * 60) {
									console.log("소요시간안에 도착가능");	
									detailSrchPlaceArr.push(searchList[i].placeNo);
									$(".detailSrchplaceNo").val(detailSrchPlaceArr);						
				  		  		}
					  		} 
						});
	
					 if(i == (searchList.length-1)){
						clearInterval(timerId);
						$("#loading").hide();
						$("[name=selectedStartPlace]").val($("select[name=startPlace] option:selected").text());
						e.target.submit();
					 }
					 i++;
				},1000);
			}
			
	});
	</script>
	<!-- 여백용 -->
	<br />
	<br />
	<br />
	<br />
	
	<!-- 테마 랜덤(선호도) 추천 위3, 아래3 -->
	<div class="container" id="random-theme">
	<h2>테마별 여행지</h2>
		<div class="row">
			<c:forEach var="theme" items="${themePlaceList}" begin="0" end="2" step="1" varStatus="vs">
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
			      <div class="card mb-3">
			      	<a href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=${theme.placeNo}">  
			        <img class="card-img-top img-fluid" 
			        	 src="${pageContext.request.contextPath}/resources/upload/place/${theme.photoList[0].renamedFilename}" alt="Card image cap">
			        <div class="card-img-overlay text-white">
					    <h4 class="card-title" style="text-shadow: 2px 2px 6px gray;">${theme.placeName}</h4>
					</div>
			        </a>
			      </div>	     
			    </div>
		    </c:forEach>
		</div>
		<div class="row">
			<c:forEach var="theme" items="${themePlaceList}" begin="3" end="5" step="1" varStatus="vs">
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
			      <div class="card mb-3">
			      	<a href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=${theme.placeNo}">
			        <img class="card-img-top img-fluid" 
			        	src="${pageContext.request.contextPath}/resources/upload/place/${theme.photoList[0].renamedFilename}" alt="Card image cap">
			        <div class="card-img-overlay text-white">
					    <h4 class="card-title" style="text-shadow: 2px 2px 6px gray;">${theme.placeName}</h4>
					</div>
			        </a>
			      </div>	     
			    </div>
		    </c:forEach>
		</div>
	</div>
	<br />
	<br />
	
	
	<div class="container">
	<h2>인기 게시글</h2>
		<div class="row" id="top3-board">
		    <c:forEach items="${boardLikeList}" var="boardLike" varStatus="vs">
			    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
			      	<a href="${pageContext.request.contextPath}/board/boardDetail.do?boardNo=${boardLike.boardNo}" style="height: 30%;">
				      <div class="card mb-3">
				        <div class="card-body">
			    	      <h4 class="card-title">${boardLike.title}</h4>
			        	  <p class="card-text">${boardLike.content}</p>
				        </div>
				      </div>	     
			        </a>
			    </div>
		    </c:forEach>
	  </div>
	  <br />
	  <br />
	  
	  <h2>인기 여행지</h2>
	  <div class="row" id="top3-place">
		    <c:forEach items="${placeLikeList}" var="placeLike" varStatus="vs">
			    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
			      <div class="card mb-3">
			      	<a href="${pageContext.request.contextPath}/place/placeDetail.do?placeNo=${placeLike.placeNo}" style="height: 30%;">  
			      	<img class="card-img-top img-fluid" src="${pageContext.request.contextPath}/resources/upload/place/${placeLike.photoList[0].renamedFilename}" alt="Card image cap">
			        <div class="card-body">
			        	<h4 class="card-title">${placeLike.placeName}</h4>
			        	<p class="card-text">${placeLike.content}</p>
			        </div>
			        </a>
			      </div>	     
			    </div>
		    </c:forEach>
	  </div>
	</div>
	
	<br />
	<br />
	<br />

	<%-- 채팅창 여는 아이콘 : 회원만 보임 --%>
	<sec:authorize access="hasRole('ADMIN') or hasRole('USER')">
	<div class="chat_icon">
	<a style="color: #f6bd3a; text-decoration: none;">
		<i class="fa fa-comments" aria-hidden="true"></i>
	</a>
	</div>
	</sec:authorize>
	
	<%-- 로그인 정보 가져오기 --%>
	<sec:authentication property="principal" var="principal"/>
	
	<!-- 채팅창 -->
	<div class="chat_box">
	    <div class="page-content page-container" id="page-content">
       <!--  <div class="padding"> -->
           <!--  <div class="row container d-flex justify-content-center"> -->
               <!--  <div class="col-md-4"> -->
                    <div class="box box-warning direct-chat direct-chat-warning">
                        <div class="box-header with-border">
                            <h3 class="box-title">문의하기</h3>
                            <div class="box-tools pull-right"> 
                            	<!--  <span data-toggle="tooltip" title="" class="badge bg-yellow" data-original-title="3 New Messages">20</span> 
	                        	  <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i> </button> 
	                            <button type="button" class="btn btn-box-tool" data-toggle="tooltip" title="" data-widget="chat-pane-toggle" data-original-title="Contacts"> <i class="fa fa-comments"></i></button> -->
	                            <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i> </button> 
                            </div>
                        </div>
                        <div class="box-body">
                            <div class="direct-chat-messages">
                            <c:if test="${principal != 'anonymousUser' && principal.id != 'admin' }">
                            	<!-- 이전 채팅기록 가져오기 -->
                            	<c:forEach items="${chatList }" var="chat">
                            		<!-- 사용자가 보낸 메세지 -->
                            		<c:if test="${chat.fromId == principal.id}">
                            		<div class="direct-chat-msg right">
	                                    <div class="direct-chat-info clearfix"> <span class="direct-chat-name pull-right">${chat.fromId}</span> <span class="direct-chat-timestamp pull-left"><fmt:formatDate value="${chat.regTime}" pattern="dd E HH:mm a"/></span> </div> <img class="direct-chat-img" src="https://img.icons8.com/office/36/000000/person-female.png" alt="message user image">
	                                    <div class="direct-chat-text"> ${chat.message } </div>
	                                </div>
                            		</c:if>
                            		
                            		<!-- 관리자로부터 받은 메세지 -->
                            		<c:if test="${chat.fromId == 'admin'}">
                            		<div class="direct-chat-msg">
	                                    <div class="direct-chat-info clearfix"> <span class="direct-chat-name pull-left">${chat.fromId}</span> <span class="direct-chat-timestamp pull-right"><fmt:formatDate value="${chat.regTime}" pattern="dd E HH:mm a"/></span> </div> <img class="direct-chat-img" src="https://img.icons8.com/color/36/000000/administrator-male.png" alt="message user image">
	                                    <div class="direct-chat-text"> ${chat.message} </div>
	                                </div>
                            		</c:if>
                            	</c:forEach>
                            	<!-- 자동응답 메세지 표시 -->
                            	<c:if test="${not empty chatList }">
                            	<hr />
                            	</c:if>
                                <div class="direct-chat-msg">
                                    <div class="direct-chat-info clearfix"> <span class="direct-chat-name pull-left">admin</span> <span class="direct-chat-timestamp pull-right">23 Jan 2:00 pm</span> </div> <img class="direct-chat-img" src="https://img.icons8.com/color/36/000000/administrator-male.png" alt="message user image">
                                    <div class="direct-chat-text"> 안녕하세요. 나홀로 나들이 관리자 입니다. 무엇을 도와드릴까요? </div>
                                </div>
                                <div class="text-center">
                                FAQ: 
                                	<input type="button" value="이용 방법" class="mb-1 btn btn-info btn-sm btn-question" />
                                	<input type="button" value="여행코스 등록" class="mb-1 btn btn-info btn-sm btn-question"/>
                                	<input type="button" value="장소 등록" class="mb-1 btn btn-info btn-sm btn-question"/>
                                </div>
                            </c:if>
                                <%-- <div class="direct-chat-msg right">
                                    <div class="direct-chat-info clearfix"> <span class="direct-chat-name pull-right">${not empty principal.id}</span> <span class="direct-chat-timestamp pull-left">23 Jan 2:05 pm</span> </div> <img class="direct-chat-img" src="https://img.icons8.com/office/36/000000/person-female.png" alt="message user image">
                                    <div class="direct-chat-text"> 여행코스 짜려면 어떻게 하나요? </div>
                                </div> --%>
                            </div>
                        </div>
                        <div class="box-footer">
                            <!-- <form action="#" method="post"> -->
                                <div class="input-group">
	                                <input type="text" name="message" placeholder="메세지를 입력하세요." class="form-control">
	                                	  <span class="input-group-btn"> 
	                               		 	 <button type="submit" class="btn btn-warning btn-flat">전송</button>
	                               	  	 </span> 
	                               	</div>
                           <!--  </form> -->
                        </div>
                    </div>
                </div>
           <!--  </div> -->
       <!--  </div> -->
 <!--    </div> -->
</div>

<!-- sockjs-client js 추가 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.2/sockjs.js"
	integrity="sha512-3/5zbNJKTwZiPFIUPL9Q6woFGvOluvYq2/rJ+C4sZUTXKhVoY3e6mSTf5RJG01lYX3atqeslmWTsxCXb147x2w=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- stomp.js추가 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"
	integrity="sha512-tL4PIUsPy+Rks1go4kQG8M8/ItpRMvKnbBjQm4d2DQnFwgcBYRRN00QdyQnWSCwNMsoY/MfJY8nHp2CzlNdtZA=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- toastr 라이브러리 추가 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css" integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script>

	//채팅창 스크롤 맨아래로
    chatScrollBottom();


	/* 웹소켓 */
	const ws = new SockJS(`http://\${location.host}${pageContext.request.contextPath}/chatting`);
	const stompClient = Stomp.over(ws);

	//웹소켓용 전역변수
	const id = "${principal eq 'anonymousUser'? 'nomember' : principal.id}";
	let fromId = ""; //관리자가 메세지 받으면 송신자 id 받을 변수 (관리자가 답장 보낼 때 필요)
	let isAuto = false;
	
	//최초 연결
	if(id != 'nomember'){
		stompClient.connect({}, frame => {
			console.log("stomp connected : ", frame);

			stompClient.subscribe(("/ask/"+id), frame => {
				console.log("message from /ask/"+id+" : ", frame);
				displayMessage(frame);

				//관리자가 사용자로부터 메세지를 받을 경우 송신자의 id를 담는다 (답장 보낼 때 필요)
				if(id === 'admin'){
					let obj = JSON.parse(frame.body);
					fromId = obj.fromId;
					//sendToastMessage(fromId, id);
				}
				/* else{
					sendToastMessage('관리자', id);
				} */
			});


		stompClient.subscribe(("/ask/noti/"+id), frame => {
				let obj = JSON.parse(frame.body);

				let senderName = obj.fromId;
				console.log("noti from /ask/noti"+id + " : ", obj);
				sendToastMessage(senderName, id);
				
			}); 

		}); 
	}

	/*
	메세지 도착 시 토스트 알림 보내기
	senderName : 메세지 보낸 사람 id
	receverId : 메세지 받는 사람 id
	*/
	function sendToastMessage(senderName, receverId){

		//알림 형태 : "honngd님으로부터 새 메세지가 도착했습니다." (SessionHandler.java에서 처리)
		let socketMsg = "chat:" + senderName + "," + receverId;
		console.log(socketMsg);
		sock.send(socketMsg);

	}


	//자동 응답용 질문 버튼 클릭
	$(".btn-question").click((e) => {
		
		const thisVal = $(e.target).val();
		console.log($(e.target).val());

		let message = "";		

		if(thisVal === '이용 방법'){
			message = "1인 여행객을 위한 여행지를 검색하고, 마음에 드는 장소를 담아 나만의 코스를 만들 수 있습니다. 또한 커뮤니티를 이용해 다른 사용자들과 장소, 여행코스 등을 공유할 수 있습니다.";
		}
		else if(thisVal === '여행코스 등록'){
			message = "[마이페이지]의 [여행코스 등록]에서 등록할 수 있습니다. 여행코스 등록은 로그인이 필요합니다.";
		}
		else if(thisVal === '장소 등록'){
			message = "[커뮤니티]에서 게시글을 작성할 때 [여행후기] 또는 [정보공유] 카테고리를 선택하면 장소를 직접 등록할 수 있습니다.";
		}
		
		isAuto = true;
		sendMessage(id, message);
		
	});




	
	// 인자로 받은 frame객체의 body 속성을 사용
	const displayMessage = ({body}) => {
		//1. json -> js obj
		let obj = JSON.parse(body);
		console.log("obj");
		console.log(obj);

		// 2. 내용만 구조분해할당
		const {fromId} = obj;
		const {message} = obj; // obj객체의 message속성만 꺼내 변수에 담음
		const date = new Date(obj.regTime);
		const dateFormat = date.customFormat("#DD# #MMM# #h#:#mm# #ampm#"); //23 Jan 2:00 pm

		// 3. 보낸이 분리하기 
		let html = "";
		if(fromId === id){
			//보낸 메세지
			html = `<div class="direct-chat-msg right">
	            <div class="direct-chat-info clearfix"> <span class="direct-chat-name pull-right">\${obj.fromId}</span> <span class="direct-chat-timestamp pull-left">\${dateFormat}</span> </div> <img class="direct-chat-img" src="https://img.icons8.com/office/36/000000/person-female.png" alt="message user image">
	            <div class="direct-chat-text">\${message}</div>
	        </div>`;
		}
		else{
			//받은 메세지
			html = `<div class="direct-chat-msg">
	            <div class="direct-chat-info clearfix"> <span class="direct-chat-name pull-left">\${obj.fromId}</span> <span class="direct-chat-timestamp pull-right">\${dateFormat}</span> </div> <img class="direct-chat-img" src="https://img.icons8.com/color/36/000000/administrator-male.png" alt="message user image">
	            <div class="direct-chat-text">\${message}</div>
	        </div>`;
			
		}

        const $messageArea = $(".direct-chat-messages");
        $messageArea.append(html);

        //스크롤 맨아래로
        chatScrollBottom();
        
	}; 

	function chatScrollBottom(){
		 const $messageTextBox = $('.direct-chat-messages'); 
	     $messageTextBox.scrollTop($messageTextBox[0].scrollHeight);
	}


	function sendMessage(id, message){
		
		let url = "/ask/"+id;

		if(id === 'admin'){
			//받은 메세지에서 사용자 아이디 추출
			url = `/ask/\${fromId}`;
		} 

		let msg = {};

		if(isAuto){
		//자동응답의 경우
			msg = {
					fromId : 'admin',
					toAddress : url,
					message : message,
					regTime : Date.now()
				};
			isAuto = false;
			
		} else{

			msg = {
					fromId : id,
					toAddress : url,
					message : message,
					regTime : Date.now()
				};
		}
		
		stompClient.send(url, {}, JSON.stringify(msg)); // url, option객체, 메세지객체
		$("[name=message]").val("").focus();


	}

	// 채팅 아이콘 버튼 클릭 시 채팅창 나타남/사라짐
	$(".chat_icon").click((e) => {
		$(".chat_box").toggleClass("active");
	});
	
	// 채팅창 x 클릭 시 채팅창 사라짐
	$(".btn-box-tool").click(() => {
		$(".chat_box").removeClass("active");
	});

	// 전송 버튼 클릭 시 메세지 전송
	$(".btn-flat").click(() => {
		const $message = $("[name=message]");
		if($message.val()){
			sendMessage(id, $message.val());
		}
	});

	// 메세지 입력 후 엔터 클릭 시 메세지 전송
	$("[name=message]").keyup((e) => {
		if (e.keyCode == 13 && $(e.target).val() != ""){
			sendMessage(id, $(e.target).val());
		}
	});

	/* 실시간알림용 웹소켓 */
	const sock = new SockJS(`http://\${location.host}${pageContext.request.contextPath}/notification`);

	sock.onopen = e => {
		console.log("onopen : ", e);
	}

		sock.onmessage = function(e) {
			console.log("onmessage : ", e);
			const {data} = e;
			console.log("data : ", data);

			//알림 뱃지에 new 띄우기

			//toast 알림
			toastr.options = {
	            closeButton: true,
	            progressBar: true,
	            showMethod: 'slideDown',
	            timeOut: 4000
	     };
	     toastr.info(data, '댓글 알림');
		}

		sock.onerror = e => {
			console.log("oneeror : ", e);
		}

		sock.onclose = e => {
			console.log("onclose : ", e);
		}
		
 

	</script>





<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>