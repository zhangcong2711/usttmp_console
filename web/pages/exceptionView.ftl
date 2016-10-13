
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

    <!-- DataTables CSS -->
    <link href="/${webRootPath}/resources/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.css" rel="stylesheet">
    <link href="/${webRootPath}/resources/datatables/media/css/jquery.dataTables.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/${webRootPath}/resources/font-awesome/css/font-awesome.css" rel="stylesheet" type="text/css">


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
                <div class="panel panel-default">
                    <div class="panel-heading">
                        Exceptin list of mining task: ${miningTask.name}
                    </div>
                    <!-- /.panel-heading -->
                    <div class="panel-body">
                        <div class="table-responsive">
                            <table id="logTable"
                                   class="table table-striped table-bordered table-hover"
                                   cellspacing="0"
                                   width="100%">
                                <thead>
                                <tr>
                                    <th>Occurrence Time</th>
                                    <th>Type</th>
                                    <th>Info</th>
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

<!-- DataTables JavaScript -->
<script src="/${webRootPath}/resources/datatables/media/js/jquery.dataTables.js"></script>
<script src="/${webRootPath}/resources/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.js"></script>

<!-- Custom Theme JavaScript -->
<script src="/${webRootPath}/resources/sbadmin/js/sb-admin-2.js"></script>

<script>

    $(document).ready(function() {

        var logTable = $('#logTable').DataTable({
            "responsive": true,
            "processing": true,
            "serverSide": true,
            "ordering": false,
            "paging": false,
            "searching": false,
            "ajax": "ajax/loadTaskLogs?miningTaskId=${miningTask.id}",
            "columns": [
                {"data": "occurrenceTime"},
                {"data": "type"},
                {"data": "info"}
            ]
        });

    });


</script>

</body>

</html>
