<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
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

#nameSuccess, #nameError {
	display: none;
}
</style>

<script
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoServiceKey}&libraries=services"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<div class="container mt-5 mb-5">
	<h1 class="text-center">장소 수정</h1>
	<div id="demo-container"
		class="border mx-auto p-3 rounded shadow p-3 mb-5 bg-body">
		<form:form id="updatePlaceFrm" method="POST" enctype="multipart/form-data">
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">장소명</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="placeName" name="placeName" value="${place.placeName}" required>
					<span class="text-primary" id="nameSuccess">등록 가능한 장소입니다.</span>
					<span class="text-danger" id="nameError">이미 등록된 장소입니다.</span>
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-form-label col-sm-2">지역</label>
				<div class="col-sm-10">
					<select class="form-select" name="localCode"
						aria-label="Default select example">
						<option name="localCode" value="L1"
							${place.localCode eq 'L1'? 'selected' : ''}>서울</option>
						<option name="localCode" value="L2"
							${place.localCode eq 'L2'? 'selected' : ''}>충청도/대전</option>
						<option name="localCode" value="L3"
							${place.localCode eq 'L3'? 'selected' : ''}>전라도/광주</option>
						<option name="localCode" value="L4"
							${place.localCode eq 'L4'? 'selected' : ''}>경기도</option>
						<option name="localCode" value="L5"
							${place.localCode eq 'L5'? 'selected' : ''}>강원도</option>
						<option name="localCode" value="L6"
							${place.localCode eq 'L6'? 'selected' : ''}>제주도</option>
						<option name="localCode" value="L7"
							${place.localCode eq 'L7'? 'selected' : ''}>경상도/부산</option>
					</select>
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">카테고리</label>
				<div class="col-sm-10">
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault1" name="categoryCode" value="C1"
							${place.categoryCode eq 'C1' ? 'checked' : ''}> <label
							class="form-check-label" for="flexRadioDefault1">랜드마크</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault2" name="categoryCode" value="C2"
							${place.categoryCode eq 'C2' ? 'checked' : ''}> <label
							class="form-check-label" for="inlineCheckbox1">맛집</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault3" name="categoryCode" value="C3"
							${place.categoryCode eq 'C3' ? 'checked' : ''}> <label
							class="form-check-label" for="inlineCheckbox1">오락</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault4" name="categoryCode" value="C4"
							${place.categoryCode eq 'C4' ? 'checked' : ''}> <label
							class="form-check-label" for="inlineCheckbox1">레저/스포츠</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio"
							id="flexRadioDefault5" name="categoryCode" value="C5"
							${place.categoryCode eq 'C5' ? 'checked' : ''}> <label
							class="form-check-label" for="inlineCheckbox1">캠핑/차박</label>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">주소</label>

				<div class="col-sm-10">
					<input type="text" class="form-control" id="newAddress"
						placeholder="주소" name="address" value="${place.address}" required>
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
					<textarea class="form-control" id="content" name="content" rows="5"
						required>${place.content}</textarea>
				</div>
			</div>
			<div class="input-group mb-3" style="padding: 0px;">
				<!-- 장소 사진 수정 -->
			</div>
			<!-- 장소 사진 보여주는 행 -->
			<div class="form-group row">
				<div class="col-lg-12">
					<div class="card mb-4">
						<div class="card-header">
							<h5 class="m-0 font-weight-bold text-success">첨부 사진</h5>
						</div>
						<div class="card-body">
							<div class="input-group mb-3">
								<input type="file" class="custom-file-input" name="upFile"
									id="upFile" multiple/> <label class="custom-file-label"
									for="upFile1" >파일을 선택하세요</label>
							</div>
							<p class="text-secondary fs-6 text-center">*파일은 최대 10개까지 등록할
								수 있습니다.</p>
							<div class="uploadResult">
								<ul class="pl-0 row"></ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<input type="hidden" name="xCoord" id="xCoord"
				value="${place.XCoord}" />
			<input type="hidden" name="yCoord" id="yCoord"
				value="${place.YCoord}" />
			<input type="hidden" name="placeNo" id="placeNo"
				value="${place.placeNo}" />
			<input type="hidden" name="nameValid" id="nameValid" value="1" />
			<!-- 전송버튼  -->
			<div class="list-group">
				<input type="submit" class="btn btn-outline-success" value="장소 수정" />
			</div>
		</form:form>
	</div>
</div>
<script>
<%-- 중복 장소 여부 --%>
$("#placeName").blur(e => {
	const placeName = $(e.target).val();
	const $nameSuccess = $("#nameSuccess");
	const $nameError = $("#nameError");
	const $nameValid = $("#nameValid");
	
	$.ajax({
		url : "${pageContext.request.contextPath}/admin/checkPlaceNameDupl.do",
		data : {placeName},
		success : (data) => {
			if(data.available) {
				$nameSuccess.show();
				$nameError.hide();
				$nameValid.val(1);
			}
			else if(data.placeName == placeName) {
				$nameError.hide();
				$nameSuccess.hide();
			}
			else {
				$nameError.show();
				$nameSuccess.hide();
				$nameValid.val(0);
			}
		},
		error : console.log
	});

});

// 업로드 한 파일 수
var fileCount = 0;
// 업로드 가능한 이미지 숫자
let totalCount = 10;
// 파일 고유 번호
var fileNum = 0;
// 첨부파일 배열
var content_files = new Array();

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

	// form submit 로직
	$("#updatePlaceFrm").submit(e => {
 			 e.preventDefault();

			const nameValid = $("#nameValid").val();
			if(nameValid == 0) {
				alert("장소 이름이 중복되었습니다. 중복된 장소명은 등록할 수 없습니다.");
				return;
			}
			var formData = new FormData(e.target);
			
			for (var i = 0; i < content_files.length; i++) {
				if(content_files[i] != null) {
					formData.append("files" + i, content_files[i]);
				}
			} 

 	 		//ajax로 파일 업로드
			$.ajax({
				url: `${pageContext.request.contextPath}/admin/updatePlace.do?cpage=${cpage}`,
				type: "POST",
				data: formData,
				processData: false,
		   	    contentType: false,
                beforeSend : function() {
                    console.log("beforeSend 호출!");
                },
		   	    success : function(data) {
					if(data) {
			   	    	location.href = "${pageContext.request.contextPath}/admin/adminPlaceList.do?cpage=${cpage}";
			   	    	console.log(data);
			   	    }
		   	     },
		   	     error: console.log,
		   	     complete: function() {
					console.log("complete 호출!");
				}  
	   	    });
		});
		
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