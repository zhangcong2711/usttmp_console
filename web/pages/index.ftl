<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

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
    
    <!-- DataTables CSS -->
    <link href="/${webRootPath}/resources/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.css" rel="stylesheet">
    <link href="/${webRootPath}/resources/datatables/media/css/jquery.dataTables.css" rel="stylesheet">

    <!-- DataTables Responsive CSS -->
    <!--link href="/${webRootPath}/resources/datatables-responsive/css/dataTables.responsive.css" rel="stylesheet"-->

    <!-- JQuery confirmation dialog -->
    <link rel="stylesheet" type="text/css" href="/${webRootPath}/resources/craftpip-jquery-confirm/jquery-confirm.css"/>



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
                    <h1 class="page-header">Dashboard</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <p>
                        <button type="button"
                                id="trackingBtn"
                                class="btn btn-primary btn-lg">Topic Tracking</button>
                        <button type="button" id="exceptionRpBtn" class="btn btn-warning">Exception Report</button>
                        <button type="button" id="stopBtn" class="btn btn-warning">Stop Task</button>
                        <button type="button" id="delBtn"  class="btn btn-danger">Delete</button>
                    </p>
                    
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            All mining tasks
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table id="taskTable"
                                       class="table table-striped table-bordered table-hover"
                                       cellspacing="0"
                                       width="100%">
                                    <thead>
                                        <tr>
                                            <th>Task ID</th>
                                            <th>Task Name</th>
                                            <th>Data tag</th>
                                            <th>Start Time</th>
                                            <th>End Time</th>
                                            <th>Time interval (hour)</th>
                                            <th>Status</th>
                                            <th>Progress</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                            <!-- /.table-responsive -->
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
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
    <script src="/${webRootPath}/resources/js/morris-data.js"></script>-->
    
    <!-- DataTables JavaScript -->
    <script src="/${webRootPath}/resources/datatables/media/js/jquery.dataTables.js"></script>
    <script src="/${webRootPath}/resources/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/${webRootPath}/resources/sbadmin/js/sb-admin-2.js"></script>

    <!-- JQuery confirmation dialog -->
    <script type="text/javascript" src="/${webRootPath}/resources/craftpip-jquery-confirm/jquery-confirm.js"></script>
    
    <script>

        var selectedTaskRow = null;

        function onTopicTrackingClick(){

            if(selectedTaskRow==null){
                alert("Please select a mining task.");
            }else{
                var taskId=selectedTaskRow["taskId"];
                window.open("trackingTopic?taskId="+taskId);
            }
        }


        function onTaskExceptionClick(){
            if(selectedTaskRow==null){
                alert("Please select a mining task.");
            }else{
                var taskId=selectedTaskRow["taskId"];
                window.open("taskException?miningTaskId="+taskId);
            }
        }


        function onStopTaskClick(){

            if(selectedTaskRow==null){
                alert("Please select a mining task.");
            }else{
                var taskId=selectedTaskRow["taskId"];
                window.location = "stopTask?miningTaskId="+taskId;
            }
        }

        function onDeleteTasklick(){

            if(selectedTaskRow==null){
                alert("Please select a mining task.");
            }else{
                var taskId=selectedTaskRow["taskId"];
                window.location = "deleteTask?miningTaskId="+taskId;
            }
        }

    	$(document).ready(function() {

//            var taskRowSelected = [];

        	var taskTable = $('#taskTable').DataTable({
    			"responsive": true,
                "processing": true,
                "serverSide": true,
                "ordering": false,
                "paging": false,
                "searching": false,
                "ajax": "ajax/loadAllTasks",
                "columns": [
                    { "data": "taskId" },
                    { "data": "taskName" },
                    { "data": "tag" },
                    { "data": "startTime" },
                    { "data": "endTime" },
                    { "data": "miningInterval" },
                    { "data": "status" },
                    { "data": "progress" }
                ],
                "columnDefs": [
                    {
                        "targets": [ 0 ],
                        "visible": false,
                        "searchable": false
                    }
                ]
    		});

            $('#taskTable tbody').on('click', 'tr', function () {
//                var id = this.id;
//                var index = $.inArray(id, taskRowSelected);
//
//                if ( index === -1 ) {
//                    taskRowSelected.push( id );
//                } else {
//                    taskRowSelected.splice( index, 1 );
//                }

//                table.rows('.selected').data()

//                $(this).toggleClass('selected');

                if ( $(this).hasClass('selected') ) {
                    $(this).removeClass('selected');
                    selectedTaskRow=null;
                }
                else {
                    taskTable.$('tr.selected').removeClass('selected');
                    $(this).addClass('selected');
                    selectedTaskRow=(taskTable.rows('.selected').data())[0];
                }
            } );

            $('#trackingBtn').on( "click", onTopicTrackingClick );
//            $('#stopBtn').on( "click", onStopTaskClick);
//            $('#delBtn').on( "click", onDeleteTasklick);


            $('#exceptionRpBtn').on( "click", onTaskExceptionClick );

            $('#delBtn').on('click', function () {
                $.confirm({
                    title: 'Warning',
                    content: 'All data (text, topic and evolution relas) related to this task will be purged and NOT restored !',
                    confirmButton: 'Yes, sure!',
                    icon: 'fa fa-warning',
                    confirmButtonClass: 'btn-warning',
                    animation: 'zoom',
                    confirm: onDeleteTasklick
                });
            });

            $('#stopBtn').on('click', function () {
                $.confirm({
                    title: 'Warning',
                    content: 'The task will be stoped and NOT resumed again (data will be saved).',
                    confirmButton: 'Yes, sure!',
                    icon: 'fa fa-warning',
                    confirmButtonClass: 'btn-warning',
                    animation: 'zoom',
                    confirm: onStopTaskClick
                });
            });
                
    	
//    		t.row.add( [
//    			'5',
//    			'aefefefe',
//    			'afefefe',
//                'afefefe',
//                'fe',
//    			'afefefe'
//        	] ).draw( false );
    	});
    	
    </script>

</body>

</html>
