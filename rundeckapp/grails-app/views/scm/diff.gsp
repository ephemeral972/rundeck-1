<%--
  Created by IntelliJ IDEA.
  User: greg
  Date: 8/27/15
  Time: 3:54 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="tabpage" content="configure"/>
    <meta name="layout" content="base"/>
    <title><g:appTitle/> - <g:message code="scmController.page.${integration}.diff.title" args="[params.project]"/></title>

</head>

<body>

<div class="row">
    <div class="col-sm-12">
        <g:render template="/common/messages"/>
    </div>
</div>

<div class="row">
    <div class="col-sm-12">
        <div class="list-group">
            <div class="list-group-item">
                <h4 class="list-group-item-heading"><g:message code="scmController.page.${integration}.diff.description"/></h4>
            </div>

            <div class="list-group-item">
                <div class="row">
                    <g:render template="/scheduledExecution/showHead" model="[scheduledExecution: job]"/>
                </div>
            </div>
            <g:set var="jobstatus" value="${integration=='export'?scmExportStatus?.get(job.extid):scmImportStatus?.get(job.extid)}"/>

            <div class="list-group-item">
                <g:set var="exportStatus" value="${scmExportStatus?.get(job.extid)}"/>
                <g:set var="importStatus" value="${scmImportStatus?.get(job.extid)}"/>
                <g:render template="/scm/statusBadge" model="[
                        showClean:true,
                        exportStatus: exportStatus?.synchState?.toString(),
                        importStatus: importStatus?.synchState?.toString(),
                        text  : '',
                        integration:integration,
                        exportCommit: exportStatus?.commit,
                        importCommit: importStatus?.commit,
                ]"/>
                <g:if test="${scmFilePaths && scmFilePaths[job.extid]}">
                    <g:if test="${scmExportRenamedPath}">
                        <div>
                            <span class="has_tooltip text-muted" title="Original repo path">
                                <g:icon name="file"/>
                                ${scmExportRenamedPath}
                            </span>
                        </div>
                    </g:if>
                    <span class="has_tooltip" title="Repo file path">
                        <g:if test="${scmExportRenamedPath}">
                            <g:icon name="arrow-right"/>
                        </g:if>

                        <g:icon name="file"/>
                        ${scmFilePaths[job.extid]}
                    </span>
                </g:if>
            </div>
            <g:if test="${jobstatus?.commit}">
                <div class="list-group-item">
                    <g:render template="commitInfo" model="[commit:jobstatus.commit,title:'Current Commit']"/>
                </div>
            </g:if>


            <g:if test="${diffResult && integration=='import' && diffResult.hasProperty("incomingCommit") && diffResult.incomingCommit}">
                <g:set var="commit" value="${diffResult.incomingCommit}"/>
                <div class="list-group-item">

                    <g:render template="commitInfo" model="[commit:commit,title:'Incoming Commit']"/>
                </div>
            </g:if>
            <g:if test="${diffResult?.oldNotFound}">

                <div class="list-group-item">
                    <div class="list-group-item-text text-info">
                        <g:message code="not.added.to.scm"/>
                    </div>
                </div>
            </g:if>
            <g:elseif test="${diffResult?.newNotFound}">

                <div class="list-group-item">
                    <div class="list-group-item-text text-warning">
                        <g:message code="file.has.been.removed.in.scm" />
                    </div>
                </div>
            </g:elseif>
            <g:elseif test="${diffResult && !diffResult.modified}">

                <div class="list-group-item">
                    <div class="list-group-item-text text-muted">
                        <g:message code="no.changes"/>
                    </div>
                </div>
            </g:elseif>
            <g:elseif test="${diffResult?.content}">
                <div class="list-group-item">
                    <g:link action="diff" controller="scm"
                            class="btn btn-link"
                            params="[project: params.project, jobId: job.extid, download: true, integration:integration]">
                        <g:icon name="download"/>
                        <g:message code="download.diff" />
                    </g:link>

                </div>

                <div id="difftext"
                     class="list-group-item scriptContent expanded apply_ace"
                     data-ace-session-mode="diff">${diffResult.content}</div>
            </g:elseif>
            <g:if test="${diffResult && (diffResult.modified || diffResult.oldNotFound)}">
                <g:link action="exportAction" controller="scm"
                        class="list-group-item ${diffResult.oldNotFound ? 'list-group-item-success' :
                                'list-group-item-info'}"
                        params="[project: params.project, jobIds: job.extid,integration:integration]">

                    <i class="glyphicon glyphicon-circle-arrow-right"></i>
                    <g:if test="${diffResult.oldNotFound}">
                        <g:message code="commit.new.file" />
                    </g:if>
                    <g:else>
                        <g:message code="button.Commit.Changes.title"/>
                    </g:else>
                </g:link>
            </g:if>
        </div>
    </div>
</div>

<!--[if (gt IE 8)|!(IE)]><!--> <g:javascript library="ace/ace"/><!--<![endif]-->
<g:javascript>
    fireWhenReady('difftext', function (z) {
        jQuery('.apply_ace').each(function () {
            _applyAce(this, '400px');
        });
    });
</g:javascript>
</body>
</html>