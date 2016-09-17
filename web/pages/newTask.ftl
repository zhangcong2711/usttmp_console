
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
    <meta http-equiv="pragma" content="no-cache" />

    <title>USTTMP -- Universal Platform of Social Text Topic Mining</title>

    <!-- Bootstrap Core CSS -->
    <link href="/${webRootPath}/resources/bootstrap/css/bootstrap.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/${webRootPath}/resources/metisMenu/metisMenu.css" rel="stylesheet">

    <!-- Timeline CSS -->
    <link href="/${webRootPath}/resources/sbadmin/css/timeline.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/${webRootPath}/resources/sbadmin/css/sb-admin-2.css" rel="stylesheet">

    <!-- Morris Charts CSS -->
    <link href="/${webRootPath}/resources/morrisjs/morris.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/${webRootPath}/resources/font-awesome/css/font-awesome.css" rel="stylesheet" type="text/css">

    <!-- Datetime Picker -->
    <link href="/${webRootPath}/resources/bootstrap-datetimepicker/css/bootstrap-datetimepicker.css" rel="stylesheet" media="screen">

    <style>
        .my-error-class {
            color:#FF0000;  /* red */
        }
    </style>


</head>

<body>

    <div id="wrapper">

        <!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="index.html">USTTMP -- Universal Platform of Social Text Topic Mining</a>
            </div>
            <!-- /.navbar-header -->

            <ul class="nav navbar-top-links navbar-right">
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-tasks fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-tasks">
                        <li>
                            <a href="#">
                                <div>
                                    <p>
                                        <strong>Task 1</strong>
                                        <span class="pull-right text-muted">40% Complete</span>
                                    </p>
                                    <div class="progress progress-striped active">
                                        <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 40%">
                                            <span class="sr-only">40% Complete (success)</span>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a class="text-center" href="#">
                                <strong>See All Tasks</strong>
                                <i class="fa fa-angle-right"></i>
                            </a>
                        </li>
                    </ul>
                    <!-- /.dropdown-tasks -->
                </li>
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-bell fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-alerts">
                        <li>
                            <a href="#">
                                <div>
                                    <i class="fa fa-comment fa-fw"></i> New Comment
                                    <span class="pull-right text-muted small">4 minutes ago</span>
                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a class="text-center" href="#">
                                <strong>See All Alerts</strong>
                                <i class="fa fa-angle-right"></i>
                            </a>
                        </li>
                    </ul>
                    <!-- /.dropdown-alerts -->
                </li>
            </ul>
            <!-- /.navbar-top-links -->

            <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">
                        <li>
                            <a href="index"><i class="fa fa-dashboard fa-fw"></i> Overview</a>
                        </li>
                        <li>
                            <a href="newTask"><i class="fa fa-edit fa-fw"></i> New</a>
                        </li>
                        <li>
                            <a href="settings"><i class="fa fa-wrench fa-fw"></i> Settings</a>
                        </li>
                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
        </nav>

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">New Task</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <form id="newTaskForm" role="form" method="post" action="createNewTask">
					<div class="form-group">
						<label>Task name</label>
						<input class="form-control" name="taskname" value="" required>
					</div>
					<div class="form-group">
						<label>Start time</label>
						<input class="form-control" id="starttime" name="starttime" value="" required>
					</div>
					<div class="form-group">
						<label>End time</label>
						<input class="form-control" id="endtime" name="endtime" value="" required>
                        <!--
						<p class="help-block">The mining task will keep going if without end time. 
						In addition, system will directly use ready made data to mine if end time has been pasted before now. </p>
						-->
					</div>
					<div class="form-group input-group">
						<label>Mining interval (hour)</label>
						<input type="text" class="form-control" name="mininginterval" value="24" required>
					</div>
					<div class="form-group">
						<label>Topic Number</label>
						<input class="form-control" name="topicnum" value="20" required>
						<p class="help-block">Topic number in one-time mining.</p>
					</div>
					<div class="form-group">
						<label>Key Word Number</label>
						<input class="form-control" name="keywordnum" value="20" required>
						<p class="help-block">Key word number in one topic.</p>
					</div>
					<div class="form-group">
						<label>Alpha</label>
						<input class="form-control" name="alpha" value="5" required>
						<p class="help-block">Just leave it as default :)</p>
					</div>
					<div class="form-group">
						<label>Beta</label>
						<input class="form-control" name="beta" value="0.01" required>
						<p class="help-block">Just leave it as default :)</p>
					</div>
					<div class="form-group">
						<label>Data Tag</label>
						<input class="form-control" name="tag" value="" required>
						<p class="help-block">Data Tag is necessary to be used for achieving specific data you want.</p>
					</div>
                    <div class="form-group">
                        <label>Preprocess component</label>
                        <select id="preprocessCp" name="preprocessCp" class="form-control">
                            <option value='none' selected="selected">NONE</option>
                            <#list preprocessCp as pp>
                                <option value='${pp["cpValue"]}'>${pp["cpName"]}</option>
                            </#list>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mining component</label>
                        <select id="miningCp" name="miningCp" class="form-control">
                            <option value='none' selected="selected">NONE</option>
                            <#list miningCp as pp>
                                <option value='${pp["cpValue"]}'>${pp["cpName"]}</option>
                            </#list>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Evolution tracking component</label>
                        <select id="trackingCp" name="trackingCp" class="form-control">
                            <option value='none' selected="selected">NONE</option>
                            <#list trackingCp as pp>
                                <option value='${pp["cpValue"]}'>${pp["cpName"]}</option>
                            </#list>
                        </select>
                    </div>
					<button type="submit" class="btn btn-default">Create</button>
				</form>
            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="/${webRootPath}/resources/js/jquery-1.9.1.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/${webRootPath}/resources/bootstrap/js/bootstrap.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/${webRootPath}/resources/metisMenu/metisMenu.js"></script>

    <!-- Morris Charts JavaScript
    <script src="/${webRootPath}/resources/raphael/raphael.js"></script>
    <script src="/${webRootPath}/resources/morrisjs/morris.js"></script>
    <script src="/${webRootPath}/resources/js/morris-data.js"></script-->

    <!-- Custom Theme JavaScript -->
    <script src="/${webRootPath}/resources/sbadmin/js/sb-admin-2.js"></script>

    <!-- Datetime Picker JavaScript -->
    <script type="text/javascript" src="/${webRootPath}/resources/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>

    <!-- Jquery Validation JavaScript -->
    <script src="/${webRootPath}/resources/jquery-validation/jquery.validate.js"></script>

    <script>

        $('#starttime').datetimepicker({
            weekStart: 1,
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            forceParse: 0,
            showMeridian: 1,
            format: "yyyy-mm-dd hh:ii:ss"
        });

        $('#endtime').datetimepicker({
            weekStart: 1,
            todayBtn:  1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            forceParse: 0,
            showMeridian: 1,
            format: "yyyy-mm-dd hh:ii:ss"
        });

        jQuery.validator.addMethod("validateComponent", function(value, element, param) {
            return 'none'!=value;
        }, $.validator.format("Please choose a effective component."));

        $("#newTaskForm").validate({
            rules: {
                miningCp: {
                    required: true,
                    validateComponent: ""
                }
            },
            messages: {
                miningCp: {
                    validateComponent: "Mining process need a effective component."
                }
            },
            errorClass: "my-error-class"
        });


    </script>
</body>

</html>
