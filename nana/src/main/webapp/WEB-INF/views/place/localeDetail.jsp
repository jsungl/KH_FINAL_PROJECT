<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>


<style>
.carousel-item>img {
	height: 25vw;
	/* height: 500px; */
	object-fit: cover;
}

.card-img-top {
	/* height: 15vw; */
	height: 200px;
	object-fit: cover;
}
</style>

<div class="container mt-3">
	<h2>제주</h2>
	<ul class="nav nav-pills nav-fill">
		<li class="nav-item"><a class="nav-link active" href="#">홈</a></li>
		<li class="nav-item"><a class="nav-link" href="#">랜드마크</a></li>
		<li class="nav-item"><a class="nav-link" href="#">맛집</a></li>
		<li class="nav-item"><a class="nav-link" href="#">오락</a></li>
		<li class="nav-item"><a class="nav-link" href="#">캠핑/차박</a></li>
		<li class="nav-item"><a class="nav-link" href="#">레저/스포츠</a></li>
	</ul>

	<!-- 회전목마+날씨+미세먼지 -->
	<div class="row mt-2">
		<div class="col-lg-8">
			<div id="carouselExampleIndicators" class="carousel slide"
				data-ride="carousel">
				<ol class="carousel-indicators">
					<li data-target="#carouselExampleIndicators" data-slide-to="0"
						class="active"></li>
					<li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
					<li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
				</ol>
				<div class="carousel-inner">
					<div class="carousel-item active">
						<img
							src="https://blog.kakaocdn.net/dn/ltih6/btqE7npU9N6/J6ZDmVJzXR0WHWKEDCJURk/img.jpg"
							class="d-block w-100" alt="...">
					</div>
					<div class="carousel-item">
						<img
							src="http://www.jejusori.net/news/photo/201805/204575_237095_0813.jpg"
							class="d-block w-100" alt="...">
					</div>
					<div class="carousel-item">
						<img
							src="https://a.cdn-hotels.com/gdcs/production18/d313/28d7ddb1-12c5-4b47-b355-515eb4db0870.jpg"
							class="d-block w-100" alt="...">
					</div>
				</div>
				<a class="carousel-control-prev" href="#carouselExampleIndicators"
					role="button" data-slide="prev"> <span
					class="carousel-control-prev-icon" aria-hidden="true"></span> <span
					class="sr-only">Previous</span>
				</a> <a class="carousel-control-next" href="#carouselExampleIndicators"
					role="button" data-slide="next"> <span
					class="carousel-control-next-icon" aria-hidden="true"></span> <span
					class="sr-only">Next</span>
				</a>
			</div>
		</div>

		<div class="col-lg-4">

			<div class="row">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">날씨</h5>
						<h6 class="card-subtitle mb-2 text-muted">Card subtitle</h6>
						<p class="card-text">Some quick example text to build on the
							card title and make up the bulk of the card's content.</p>
						<a href="#" class="card-link">Card link</a> <a href="#"
							class="card-link">Another link</a>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">미세먼지</h5>
						<h6 class="card-subtitle mb-2 text-muted">Card subtitle</h6>
						<p class="card-text">Some quick example text to build on the
							card title and make up the bulk of the card's content.</p>
						<a href="#" class="card-link">Card link</a> <a href="#"
							class="card-link">Another link</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 카테고리 시작 -->
	<h4 class="mt-5 d-inline-block">랜드마크</h4> <span>&nbsp;&nbsp;&nbsp;상세보기 </span>
	<div class="row">
		<div class="col-lg-4 mt-3">
			<div class="card">
				<img class="card-img-top"
					src="https://api.cdn.visitjeju.net/photomng/imgpath/201908/16/b7b0e09e-0724-4c47-a904-2d92428714a1.jpg"
					alt="Card image cap">
				<div class="card-body">
					<h5 class="card-title">아부오름</h5>
					<p class="card-text">
						<i class="fa fa-heart" aria-hidden="true"></i> <span class="like-cnt">0</span> &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> <span class="board-cnt">0</span>
					</p>
				</div>
			</div>
		</div>
		<div class="col-lg-4 mt-3">
			<div class="card">
				<img class="card-img-top"
					src="https://api.cdn.visitjeju.net/photomng/imgpath/202105/14/600f0b14-4751-47b7-a31e-43a95efa8240.jpg"
					alt="Card image cap">
				<div class="card-body">
					<h5 class="card-title">아르떼뮤지엄</h5>
					<p class="card-text">
						<i class="fa fa-heart" aria-hidden="true"></i> <span class="like-cnt">0</span> &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> <span class="board-cnt">0</span>
					</p>
				</div>
			</div>
		</div>
		<div class="col-lg-4 mt-3">
			<div class="card">
				<img class="card-img-top"
					src="https://www.visitjeju.net/ckImage/201611/ckeditor_760707530032599838.jpg"
					alt="Card image cap">
				<div class="card-body">
					<h5 class="card-title">제주양떼목장</h5>
					<p class="card-text">
						<i class="fa fa-heart" aria-hidden="true"></i> <span class="like-cnt">0</span> &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> <span class="board-cnt">0</span>
					</p>
				</div>
			</div>
		</div>
	</div>
	<!-- 카테고리 끝 -->
	
		<!-- 카테고리 시작 -->
	<h4 class="mt-5 d-inline-block">랜드마크</h4> <span>&nbsp;&nbsp;&nbsp;상세보기 </span>
	<div class="row">
		<div class="col-lg-4 mt-3">
			<div class="card">
				<img class="card-img-top"
					src="https://api.cdn.visitjeju.net/photomng/imgpath/201908/16/b7b0e09e-0724-4c47-a904-2d92428714a1.jpg"
					alt="Card image cap">
				<div class="card-body">
					<h5 class="card-title">아부오름</h5>
					<p class="card-text">
						<i class="fa fa-heart" aria-hidden="true"></i> <span class="like-cnt">0</span> &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> <span class="board-cnt">0</span>
					</p>
				</div>
			</div>
		</div>
		<div class="col-lg-4 mt-3">
			<div class="card">
				<img class="card-img-top"
					src="https://api.cdn.visitjeju.net/photomng/imgpath/202105/14/600f0b14-4751-47b7-a31e-43a95efa8240.jpg"
					alt="Card image cap">
				<div class="card-body">
					<h5 class="card-title">아르떼뮤지엄</h5>
					<p class="card-text">
						<i class="fa fa-heart" aria-hidden="true"></i> <span class="like-cnt">0</span> &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> <span class="board-cnt">0</span>
					</p>
				</div>
			</div>
		</div>
		<div class="col-lg-4 mt-3">
			<div class="card">
				<img class="card-img-top"
					src="https://www.visitjeju.net/ckImage/201611/ckeditor_760707530032599838.jpg"
					alt="Card image cap">
				<div class="card-body">
					<h5 class="card-title">제주양떼목장</h5>
					<p class="card-text">
						<i class="fa fa-heart" aria-hidden="true"></i> <span class="like-cnt">0</span> &nbsp;&nbsp;&nbsp; <i class="fa fa-list" aria-hidden="true"></i> <span class="board-cnt">0</span>
					</p>
				</div>
			</div>
		</div>
	</div>
	<!-- 카테고리 끝 -->

</div>



<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
