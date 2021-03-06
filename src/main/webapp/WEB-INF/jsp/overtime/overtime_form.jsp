<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="icon" tagdir="/WEB-INF/tags/icons" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="asset" uri="/WEB-INF/asset.tld" %>

<!DOCTYPE html>
<html lang="${language}">
<head>
    <title>
        <c:choose>
            <c:when test="${overtime.id == null}">
                <spring:message code="overtime.record.header.title.new"/>
            </c:when>
            <c:otherwise>
                <spring:message code="overtime.record.header.title.edit"/>
            </c:otherwise>
        </c:choose>
    </title>
    <uv:custom-head/>
    <script>
        window.uv = {};
        window.uv.personId = '<c:out value="${person.id}" />';
        window.uv.apiPrefix = "<spring:url value='/api' />";
    </script>
    <uv:datepicker-localisation />
    <link rel="stylesheet" type="text/css" href="<asset:url value='account_form~app_form~app_statistics~overtime_form~sick_note_form~sick_notes~workingtime_form.css' />"/>
    <link rel="stylesheet" type="text/css" href="<asset:url value='account_form~app_form~app_statistics~overtime_form~person_overview~sick_note_form~sick_notes~workingtime_form.css' />"/>
    <script defer src="<asset:url value='npm.duetds.js' />"></script>
    <script defer src="<asset:url value='npm.date-fns.js' />"></script>
    <script defer src="<asset:url value='account_form~app_form~app_statistics~overtime_form~sick_note_form~sick_notes~workingtime_form.js' />"></script>
    <script defer src="<asset:url value='account_form~app_form~app_statistics~overtime_form~person_overview~sick_note_form~sick_notes~workingtime_form.js' />"></script>
    <script defer src="<asset:url value='account_form~app_detail~app_form~app_statistics~overtime_form~person_overview~sick_note_form~sick_no~95889e93.js' />"></script>
    <script defer src="<asset:url value='overtime_form.js' />"></script>
</head>
<body>

<spring:url var="URL_PREFIX" value="/web"/>

<uv:menu/>

<c:set var="DATE_PATTERN">
    <spring:message code="pattern.date"/>
</c:set>

<div class="content">
    <div class="container">
        <div class="row">
            <c:choose>
                <c:when test="${overtime.id == null}">
                    <c:set var="ACTION" value="${URL_PREFIX}/overtime"/>
                </c:when>
                <c:otherwise>
                    <c:set var="ACTION" value="${URL_PREFIX}/overtime/${overtime.id}"/>
                </c:otherwise>
            </c:choose>

            <form:form method="POST" action="${ACTION}" modelAttribute="overtime" cssClass="form-horizontal">
                <form:hidden path="id" value="${overtime.id}"/>
                <form:hidden path="person" value="${overtime.person.id}"/>
                <div class="form-section">
                    <div class="col-xs-12">
                        <c:if test="${not empty errors.globalErrors}">
                            <div class="alert alert-danger">
                                <form:errors/>
                            </div>
                        </c:if>
                    </div>
                    <div class="col-xs-12">
                        <uv:section-heading>
                            <h2>
                                <c:choose>
                                    <c:when test="${overtime.id == null}">
                                        <spring:message code="overtime.record.new"/>
                                    </c:when>
                                    <c:otherwise>
                                        <spring:message code="overtime.record.edit"/>
                                    </c:otherwise>
                                </c:choose>
                            </h2>
                        </uv:section-heading>
                    </div>
                    <div class="col-md-4 col-md-push-8">
                        <span class="help-block tw-text-sm">
                            <icon:information-circle className="tw-w-4 tw-h-4" solid="true" />
                            <spring:message code="overtime.data.description"/>
                        </span>
                    </div>
                    <div class="col-md-8 col-md-pull-4">
                        <c:if test="${signedInUser.id != overtime.person.id}">
                            <div class="form-group">
                                <label class="control-label col-md-3">
                                    <spring:message code="overtime.data.person"/>:
                                </label>
                                <div class="col-md-9">
                                    <p class="form-control-static"><c:out value="${overtime.person.niceName}"/></p>
                                </div>
                            </div><%-- End of person form group --%>
                        </c:if>
                        <div class="form-group is-required">
                            <label class="control-label col-md-3" for="startDate">
                                <spring:message code="overtime.data.startDate"/>:
                            </label>
                            <div class="col-md-9">
                                <form:input path="startDate" data-iso-value="${overtime.startDateIsoValue}"
                                            cssClass="form-control" cssErrorClass="form-control error"
                                            autocomplete="off" placeholder="${DATE_PATTERN}"/>
                                <uv:error-text>
                                    <form:errors path="startDate" />
                                </uv:error-text>
                            </div>
                        </div>
                            <%-- End of start date form group --%>
                        <div class="form-group is-required">
                            <label class="control-label col-md-3" for="endDate">
                                <spring:message code="overtime.data.endDate"/>:
                            </label>
                            <div class="col-md-9">
                                <form:input path="endDate" data-iso-value="${overtime.endDateIsoValue}"
                                            cssClass="form-control" cssErrorClass="form-control error"
                                            autocomplete="off" placeholder="${DATE_PATTERN}"/>
                                <uv:error-text>
                                    <form:errors path="endDate" />
                                </uv:error-text>
                            </div>
                        </div>
                            <%-- End of end date form group --%>
                        <div class="form-group is-required">
                            <label class="control-label col-md-3" for="numberOfHours">
                                <spring:message code="overtime.data.numberOfHours"/>:
                            </label>
                            <div class="col-md-9">
                                <form:input path="numberOfHours" cssClass="form-control"
                                            cssErrorClass="form-control error"/>
                                <uv:error-text>
                                    <form:errors path="numberOfHours" />
                                </uv:error-text>
                            </div>
                        </div>
                            <%-- End of number of overtime form group --%>
                        <div class="form-group">
                            <label class="control-label col-md-3" for="comment">
                                <spring:message code="overtime.data.comment"/>:
                            </label>
                            <div class="col-md-9">
                                <span id="char-counter"></span><spring:message code="action.comment.maxChars"/>
                                <form:textarea path="comment" cssClass="form-control" rows="2"
                                               onkeyup="count(this.value, 'char-counter');"
                                               onkeydown="maxChars(this,200); count(this.value, 'char-counter');"/>
                                <uv:error-text>
                                    <form:errors path="comment" />
                                </uv:error-text>
                            </div>
                        </div>
                            <%-- End of comment form group --%>
                    </div>
                </div><%-- End of first form section --%>
                <div class="form-section">
                    <div class="col-xs-12">
                        <hr/>
                        <button class="btn btn-success col-xs-12 col-sm-5 col-md-2" type="submit">
                            <spring:message code="action.save"/>
                        </button>
                        <button class="btn btn-default back col-xs-12 col-sm-5 col-md-2 pull-right" type="button">
                            <spring:message code="action.cancel"/>
                        </button>
                    </div>
                </div><%-- End of second form section --%>
            </form:form>
        </div>
        <%-- End of row --%>
    </div>
    <%-- End of container --%>
</div>
<%-- End of content --%>

</body>
</html>
