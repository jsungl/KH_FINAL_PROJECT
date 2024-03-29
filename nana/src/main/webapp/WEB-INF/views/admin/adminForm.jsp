<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- header --%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="나홀로 나들이" name="title" />
</jsp:include>
<style>
div#demo-container{
	width:550px;
}
</style>

<div id="demo-container" 
	 class="border border-secondary mx-auto p-3 rounded">
	<!-- https://getbootstrap.com/docs/4.1/components/forms/#readonly-plain-text -->
	<form id="devFrm">
		<div class="form-group row">
		  <label for="name" class="col-sm-2 col-form-label">장소명</label>
		  <div class="col-sm-10">
		    <input type="text" class="form-control" id="placeName" name="placeName" required>
		  </div>
		</div>
		<div class="form-group row">
		  <label for="name" class="col-sm-2 col-form-label">장소명</label>
		  <div class="col-sm-10">
		    <input type="text" class="form-control" id="placeName" name="placeName" required>
		  </div>
		</div>
		
		
		<%-- spring 프로젝트에서 가져온 거 --%>
		<div class="form-group row">
		  <label for="career" class="col-sm-2 col-form-label">개발경력</label>
		  <div class="col-sm-10">
		    <input type="number" class="form-control" id="career" name="career" value="0" required>
		  </div>
		</div>
		<div class="form-group row">
		  <label for="email" class="col-sm-2 col-form-label">이메일</label>
		  <div class="col-sm-10">
		    <input type="email" class="form-control" id="email" name="email" required>
		  </div>
		</div>
	  	<!-- https://getbootstrap.com/docs/4.1/components/forms/#inline -->
	    <div class="form-group row">
	    	<label class="col-sm-2 col-form-label">성별</label>
	    	<div class="col-sm-10">
			    <div class="form-check form-check-inline">
				  <input class="form-check-input" type="radio" name="gender" id="gender0" value="M">
				  <label class="form-check-label" for="gender0">남</label>
				</div>
				<div class="form-check form-check-inline">
				  <input class="form-check-input" type="radio" name="gender" id="gender1" value="F">
				  <label class="form-check-label" for="gender1">여</label>
				</div>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">개발언어</label>
			<div class="col-sm-10">
				<div class="form-check form-check-inline">
				  <input class="form-check-input" type="checkbox" name="lang" id="Java" value="Java">
				  <label class="form-check-label" for="Java">Java</label>
				</div>
				<div class="form-check form-check-inline">
				  <input class="form-check-input" type="checkbox" name="lang" id="C" value="C">
				  <label class="form-check-label" for="C">C</label>
				</div>
				<div class="form-check form-check-inline">
				  <input class="form-check-input" type="checkbox" name="lang" id="Javascript" value="Javascript">
				  <label class="form-check-label" for="Javascript">Javascript</label>
				</div>	
				<div class="form-check form-check-inline">
				  <input class="form-check-input" type="checkbox" name="lang" id="Python" value="Python">
				  <label class="form-check-label" for="Python">Python</label>
				</div>
			</div>
		</div>
	</form>
	<!-- 전송버튼  -->
	<div class="list-group">
	  <button type="button" onclick="submitDev('dev1');" class="list-group-item list-group-item-action">파라미터 핸들링 - HttpServletRequest</button>
	  <button type="button" onclick="submitDev('dev2');" class="list-group-item list-group-item-action">@RequestParam</button>
	  <button type="button" onclick="submitDev('dev3');" class="list-group-item list-group-item-action">@ModelAttribute 커맨드객체</button>
	  <button type="button" onclick="submitDev('dev4');" class="list-group-item list-group-item-action">Validator</button>
	  <button type="button" onclick="submitDev('insertDev');" class="list-group-item list-group-item-action">Database에 등록</button>
	</div>
</div>
<script>
function submitDev(id){
	var $devFrm = $("#devFrm");
	$devFrm
		.attr("action", `${pageContext.request.contextPath}/demo/\${id}.do`)
		.attr("method", "POST")
		.submit();
}
</script>
<%-- footer --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>