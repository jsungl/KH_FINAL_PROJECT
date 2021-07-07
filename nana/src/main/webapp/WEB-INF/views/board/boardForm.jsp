<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title"/>
</jsp:include>

<sec:authentication property="principal.username" var="user_id" />

<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoServiceKey}&libraries=services"></script>
	
	<style>

div#demo-container {
	width: 550px;
}
.img-container>img {
	height: 8vw;
	width: 8vw;
}
.uploadResult ul li {
	list-style: none;
	float: left;
	display: inline-block;
}
.btn.btn-danger {
	border-radius: 50%;
	float: right;
}
.filename {
	float: left;
}
.img-container {
	display: inline-block;
}
</style>


<h2 class="mt-3" style="text-align: center;">게시글 작성</h2><br>
<div style="width: 60%; margin: auto;">
	<form:form id="boardFrm" method="post" action="${pageContext.request.contextPath}/board/insertBoard.do?${_csrf.parameterName}=${_csrf.token}">
		<select class="custom-select inline-block" name="category" id="board-category" required style="width: 20%;">
		  <option selected>카테고리</option>
          <option value="chat">잡담</option>
          <option value="review">여행후기</option>
          <option value="info">정보공유</option>
		</select>
		<c:if test="${not empty board }">
		<input type="hidden" name="boardNo" value="${board.boardNo}" />
		</c:if>
		<input type="text" name="title" class="inline-block" style="width: 75%;" placeholder="제목" value="${board.title }" required/>
		<br><br> 
		<textarea id="summernote" name="content"></textarea>
		<input type="hidden" name="id" value="<c:if test="${not empty user_id}">${user_id}</c:if>" />
		<br>
		
		<div id="list-wrapper" style="display: none;">
		<h5>나의 여행코스 선택</h5>
		<div id="courseList" class="border" style="height: 220px; overflow:auto;">
		<table class="table table-striped">
		  <thead>
		    <tr>
		      <th scope="col">선택</th>
		      <th scope="col">여행코스</th>
		      <th scope="col">날짜</th>
		    </tr>
		  </thead>
		  <tbody>
		  <c:forEach items="${courseList}" var="course">
		   <tr>
		      <td><input type="radio" name="courseNo" value="${course.courseNo}"/></td>
		      <td>${course.title}</td>
		      <td><fmt:formatDate value="${course.regDate}" pattern="yyyy/MM/dd"/></td>
		    </tr>
		  
		  </c:forEach>
		  </tbody>
		</table>
		</div>
		</div>
		<!--  <input type="search" placeholder="여행 코스 제목 검색..." id="searchCourse" class="form-control col-sm-8 d-inline" autofocus /> -->
		<br>
		<div id="searchPlaceWrapper" style="display:none;">
			<h5>게시글과 연관된 장소 선택</h5>


			<c:if test="${not empty board }">
			<input type="search" placeholder="${place.placeName}" id="searchPlace" class="form-control col-sm-8 d-inline mb-2" autofocus />
			<input type="hidden" name="placeNo" value="${board.placeNo}"/>
			</c:if>
			<c:if test="${empty board}">
			<input type="search" placeholder="장소명 검색..." id="searchPlace" class="form-control col-sm-8 d-inline mb-2" autofocus />
			<input type="hidden" name="placeNo" value="0"/>
			</c:if>
			<br>
			<span>원하는 장소가 없나요? </span>
			<button type="button" id="btn-placeFrm" class="btn btn-outline-warning">직접 등록하기</button>
		</div>
	
		
		</form:form>
		
	
	
		
	 	<form:form id="placeFrm" class="border p-2" style="display:none; width: 550px;" method="POST" 
	 		enctype="multipart/form-data">
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">장소명</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="placeName" name="placeName" required>
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-form-label col-sm-2">지역</label>
				<div class="col-sm-10">
					<select class="form-select" name="localCode" aria-label="Default select example" required>
						<option name="localCode" value="L1">서울</option>
						<option name="localCode" value="L2">충청도/대전</option>
						<option name="localCode" value="L3">전라도/광주</option>
						<option name="localCode" value="L4">경기도</option>
						<option name="localCode" value="L5">강원도</option>
						<option name="localCode" value="L6">제주도</option>
						<option name="localCode" value="L7">경상도/부산</option>
					</select>
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">카테고리</label>
				<div class="col-sm-10">
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault1" name="categoryCode" value="C1">
							<label class="form-check-label" for="flexRadioDefault1">랜드마크</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault2" name="categoryCode" value="C2">
							<label class="form-check-label" for="inlineCheckbox1">맛집</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault3" name="categoryCode" value="C3">
							<label class="form-check-label" for="inlineCheckbox1">오락</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault4" name="categoryCode" value="C4">
							<label class="form-check-label" for="inlineCheckbox1">레저/스포츠</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault5" name="categoryCode" value="C5">
							<label class="form-check-label" for="inlineCheckbox1">캠핑/차박</label>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">주소</label>

				<div class="col-sm-10">
					<!--  <input type="text" class="form-control" id="placeName" name="placeName" required> -->
					<input type="text" class="form-control" id="newAddress" placeholder="주소" name="address" required>
					<input type="button" onclick="sample5_execDaumPostcode()"
						value="주소 검색"><br>
					<%-- 카카오 지도 불러오기 --%>
					<div class="col-sm-10 p-0">
						<div id="map" class="mt-3 mb-3"
							style="width: 425px; height: 300px; display: none"></div>
					</div>
				</div>
			</div>

			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">상세정보</label>
				<div class="col-sm-10">
					<textarea class="form-control" id="content" name="content" rows="5" required></textarea>
				</div>
			</div>
			<div class="input-group mb-3" style="padding: 0px;">
				<!-- 				<div class="input-group-prepend" style="padding: 0px;">
					<span class="input-group-text">장소사진</span>
				</div>
				<!-- 장소 사진 수정 -->
			</div>
			<!-- 장소 사진 보여주는 행 -->
			<div class="form-group row">
				<div class="col-lg-12">
					<div class="card mb-4">
						<div class="card-header">
							<h5 class="m-0 font-weight-bold text-warning">첨부 사진</h5>
						</div>
						<div class="card-body">
							<div class="input-group mb-3">
								<input type="file" class="custom-file-input" name="upFile"
									id="upFile" multiple />
								<label class="custom-file-label"
									for="upFile1">파일을 선택하세요</label>
							</div>
							<div class="uploadResult">
								<ul class="pl-0"></ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<input type="hidden" name="xCoord" id="xCoord" value="" required/>
			<input type="hidden" name="yCoord" id="yCoord" value="" required/>
			<input type="hidden" name="fromUser" value="${user_id eq 'admin' ? 0 : 1 }" />

			<!-- 전송버튼  -->
			<div class="list-group">
				<input type="submit" id="btn-insertPlace" class="btn btn-outline-warning" value="장소 등록" />
			</div>
		</form:form>
	
	
		<br>
		<input class="btn btn-warning mx-auto" id="subBtn" type="button" value="게시글 등록"/>
	
</div>

<br><br><br><br><br><br><br>


<script>

//업로드 한 파일 수
var fileCount = 0;
// 업로드 가능한 이미지 숫자
let totalCount = 10;
// 파일 고유 번호
var fileNum = 0;
// 첨부파일 배열
var content_files = new Array();

const id = "${user_id}";
console.log("id= ", id);
$(document).ready(function(){
	//summernote editer
	  $('#summernote').summernote({
		  <c:if test="${empty board}">
		  placeholder: '내용을 입력하세요.',
		  </c:if>
        tabsize: 2,
        height: 300
      });


	  <c:if test="${not empty board}">
	  $('#summernote').summernote('pasteHTML', '${board.content}');
	  </c:if>
	//게시글 연관 장소 검색
    $( "#searchPlace" ).autocomplete({
        
    	source: function(request, response){
    		   $.ajax({
    			   url: "${pageContext.request.contextPath}/search/searchPlace.do",
    			   data: {
    				   keyword: request.term
    			   },
    			   success: function(data){
    				  const {searchPlaceList} = data;
    				  //배열, JS버전 map()함수
    				  const arr = 
    				  searchPlaceList.map((place) => {
						console.log(place);
						return {
							//jQuery autocomplate 에서 필요한 속성. label, value 
								label : place.placeName,
								value : place.placeName,
								place
							}
	        			});
    				  
    				  //콜백함수 response()호출
    				  response(arr); 
    			   },
    			   error: function(xhr, status, err){
    				   console.log(xhr, status, err);
    			   }
    		   });
    	   }, 
    	   select: function(event, selected){
    		   //선택한 값 가져오기 
    		   console.log(event);
    		   console.log(selected); //selected함수에 item객체가 있고 그 안에 label속성이 있음
    		   const placeNo = selected.item.place.placeNo;
    		   $("[name=placeNo]").val(placeNo);
    	   },
    	  minLength: 1 //1글자 이상 쳐야 검색됨
    });
	
	//장소 등록 폼 토글버튼
	$("#btn-placeFrm").click(() => {
		$("#placeFrm").toggle();
		
	});
	
	//게시글 신규 등록 시 카테고리 default값 : 잡담(chat)
	
	<c:if test="${not empty board}">
	$("#board-category").val('${board.category}');
	</c:if>
	<c:if test="${empty board}">
	$("#board-category").val('chat');
	</c:if>

	
	const category = $("#board-category").val();
	setFormBycategory(category);
	
	$("#board-category").change((e) => {
		let category2 = $("#board-category").val();
		console.log(category2);
		setFormBycategory(category2);
	});
	
	//게시글 폼 제출
	$("#subBtn").click(() => {
		const $boardFrm = $("#boardFrm");
		const $courseNoChecked = $("[name=courseNo]:checked");
		//console.log($courseNoChecked);

		if($courseNoChecked.length === 0 && category === 'review'){
			alert("여행후기에는 여행코스 선택이 필요합니다.");
		}
		else{
		console.log($courseNoChecked.val());

		<c:if test="${not empty board}">
		$boardFrm.attr("action", "${pageContext.request.contextPath}/board/updateBoard.do?${_csrf.parameterName}=${_csrf.token}");
		$boardFrm.submit();
		</c:if>
		
		<c:if test="${empty board}">
		$boardFrm.submit();
		</c:if>
		}


	});
	
	//장소 등록 폼 제출
	$("#placeFrm").submit(e => {
		e.preventDefault();
		const frmData = new FormData(e.target);
		for (var i = 0; i < content_files.length; i++) {
			if(content_files[i] != null) {
				frmData.append("files" + i, content_files[i]);
			}
		} 
		
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/adminPlaceForm.do",
			type: "POST",
			data: frmData,
			processData: false,
			contentType: false,
			success(data){
				console.log(data);
				alert(data.msg);
				//장소 검색창에 장소명 넣기
				$("#searchPlace").attr("placeholder", data.place.placeName);
				//장소번호 hidden input에 삽입
				$("[name=placeNo]").val(data.place.placeNo);
			},
			error: console.log,
			complete(){
				e.target.reset();
				$("#placeFrm").hide();
			}
		
		});

		
		
	});
	<%-- 첨부된 파일을 추가했을 때 이벤트 --%>
	$("[name=upFile]").change(e => {
			//파일 가져오기
			var files = $(e.target).prop('files');
			//라벨 가져오기
			var $label = $(e.target).next();
			console.log(files);

			// fileList -> Array로 형변환
			var filesArr = Array.prototype.slice.call(files);
			console.log(filesArr);

			if(fileCount + filesArr.length > totalCount) {
				alert("파일은 최대" + totalCount + "까지 업로드 할 수 있습니다.");
				return;
			}
			else
				fileCount = fileCount + filesArr.length;


			filesArr.forEach(function (f){
				var reader = new FileReader();
				reader.onload = function(e) {
					content_files.push(f);
					$(".uploadResult ul").append(
						"<li class='p-3 col-6' id='file" + fileNum +"'><div class='name-container'><span class='pl-1 pr-1 filename'>" + f.name + "</span>"
						+ "<button type='button' class='btn btn-danger btn-sm mb-1' onclick='upFileDelete(" + fileNum + ")'><i class='fa fa-times'></i></button></div>"
						+ "<div class='img-container'><img class='d-block' src='" + e.target.result + "' /></div><li>"
					);
					fileNum++;
					console.log(fileNum);
				};
				reader.readAsDataURL(f);
				console.log("fileCount = ", fileCount);
			});
			console.log("content file = ", content_files);
				$("#upFile").val("");		
			});
	
	
});

function setFormBycategory(category){
	if(category === 'review'){
		$("#searchPlaceWrapper").show();
		$("#list-wrapper").show();	
	}
	else if(category === 'info'){
		$("#searchPlaceWrapper").show();
		$("#list-wrapper").hide();	
	}
	else{
		$("#searchPlaceWrapper").hide();
		$("#list-wrapper").hide();
	}
}


function upFileDelete(no) {
	if(confirm("파일을 삭제하시겠습니까?")) {
		//화면 상에 보이는 이미지 지우기
		var li = $("#file" + no);
		/* console.log(li); */
		li.remove();
		fileCount--;
		//Array 파일 지우기
		/* content_files.splice(no, 1); */ //index부터 1개까지의 배열 삭제
		content_files[no] = null; //배열에 null값을 넣음
		console.log(content_files); //배열이 삭제되었는지 확인
	}
}
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div
	mapOption = {
		center : new daum.maps.LatLng(37.537187, 127.005476), // 지도의 중심좌표
		level : 5
	// 지도의 확대 레벨
	};
	//지도를 미리 생성
	var map = new daum.maps.Map(mapContainer, mapOption);
	//주소-좌표 변환 객체를 생성
	var geocoder = new daum.maps.services.Geocoder();
	//마커를 미리 생성
	var marker = new daum.maps.Marker({
		position : new daum.maps.LatLng(37.537187, 127.005476),
		map : map
	});
	function sample5_execDaumPostcode() {
		new daum.Postcode({
			oncomplete : function(data) {
				console.log(data);
				var addr = data.address; // 우편번호 검색에서 얻어낸 새로운 주소 변수
				// 주소 정보를 해당 필드에 넣는다.
				document.getElementById("newAddress").value = addr;
				// 주소로 상세 정보를 검색
				geocoder.addressSearch(data.address, function(results, status) {
					// 정상적으로 검색이 완료됐으면
					if (status === daum.maps.services.Status.OK) {
						var result = results[0]; //첫번째 결과의 값을 활용
						// 해당 주소에 대한 x,y 좌표를 받아서
						var coords = new daum.maps.LatLng(result.y, result.x);
						// 지도를 보여준다.
						mapContainer.style.display = "block";
						map.relayout();
						// 지도 중심을 변경한다.
						map.setCenter(coords);
						// 마커를 결과값으로 받은 위치로 옮긴다.
						marker.setPosition(coords)
						//x,y 좌표를 input태그에 저장한다
						document.getElementById("xCoord").value = result.x;
						document.getElementById("yCoord").value = result.y;
					}
				});
			}
		}).open();
	}
</script>
<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
