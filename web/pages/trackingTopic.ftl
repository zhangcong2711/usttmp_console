
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
    <!--<link href="/${webRootPath}/resources/sbadmin/css/timeline.css" rel="stylesheet">-->

    <!-- Custom CSS -->
    <link href="/${webRootPath}/resources/sbadmin/css/sb-admin-2.css" rel="stylesheet">

    <!-- Morris Charts CSS -->
    <!--<link href="/${webRootPath}/resources/morrisjs/morris.css" rel="stylesheet">-->

    <!-- Custom Fonts -->
    <link href="/${webRootPath}/resources/font-awesome/css/font-awesome.css" rel="stylesheet" type="text/css">

    <style>

        @import url(/${webRootPath}/resources/topicEvolution/topicEvolutionDiagram.css);

        #chart {
            height: 500px;
        }

        .node rect {
            cursor: move;
            fill-opacity: .9;
            shape-rendering: crispEdges;
        }

        .node text {
            pointer-events: none;
            text-shadow: 0 1px 0 #fff;
        }

        .link {
            fill: none;
            stroke: #000;
            stroke-opacity: .2;
        }

        .link:hover {
            stroke-opacity: .5;
        }

    </style>


</head>

<body>

<div id="wrapper">

    <div class="row">
        <div class="panel panel-default">
            <div class="panel-heading">
                Topic Tracking: ${task.name}   Mining Interval: ${task.miningInterval}   Alpha: ${task.alpha}   Beta: ${task.beta}
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body" style="width:100%">
                <!--
                <div class="alert alert-info" style="font-size:40px">
                    Loading......
                    <img src="/${webRootPath}/resources/icons/loading.gif"/>
                </div>
                -->
                <p id="chart">
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.row -->

</div>
<!-- /#wrapper -->

<!-- jQuery -->
<script src="/${webRootPath}/resources/js/jquery-1.9.1.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="/${webRootPath}/resources/bootstrap/js/bootstrap.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="/${webRootPath}/resources/metisMenu/metisMenu.js"></script>

<!-- Custom Theme JavaScript -->
<script src="/${webRootPath}/resources/sbadmin/js/sb-admin-2.js"></script>

<script src="/${webRootPath}/resources/d3/d3.v2.js" charset="utf-8"></script>
<!--<script src="/${webRootPath}/resources/sankey-diagram/sankey.js"></script>-->
<script src="/${webRootPath}/resources/topicEvolution/topicEvolutionDiagram.js"></script>
<script>

    var margin = {top: 1, right: 1, bottom: 6, left: 1},
            width = 960 - margin.left - margin.right,
            height = 500 - margin.top - margin.bottom;

    var formatNumber = d3.format(",.0f"),
            format = function(d) { return formatNumber(d) + " TWh"; },
            color = d3.scale.category20();

    var svg = d3.select("#chart").append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var topicEvolutionDiagram = d3.topicEvolutionDiagram()
            .topicNum(5)
            .nodeWidth(15)
            .nodePadding(10)
            .size([width, height]);

    var path = topicEvolutionDiagram.link();

    d3.json("ajax/getTopicDataByTaskId?taskId=${task.id}", function(topicData) {

        topicEvolutionDiagram
                .nodes(topicData.nodes)
                .links(topicData.links)
                .layout();

        var node = svg.append("g").selectAll(".node")
                .data(topicData.nodes)
                .enter().append("g")
                .attr("class", "node")
                .attr("transform", function(d) {
                    return "translate(" + d.x + "," + d.y + ")";
                })
                .call(d3.behavior.drag()
                        .origin(function(d) { return d; })
                        .on("dragstart", function() { this.parentNode.appendChild(this); })
                        .on("drag", dragmove));

        node.append("rect")
                .attr("height", function(d) { return d.barHeight; })
                .attr("width", topicEvolutionDiagram.nodeWidth())
                .style("fill", function(d) { return d.color = color(d.name.replace(/ .*/, "")); })
                .style("stroke", function(d) { return d3.rgb(d.color).darker(2); })
                .append("title")
                .text(function(d) {
                    return d.name;
                });

        node.append("text")
                .attr("x", -6)
                .attr("y", function(d) { return d.barHeight / 2; })
                .attr("dy", ".35em")
                .attr("text-anchor", "end")
                .attr("transform", null)
                .text(function(d) {

                    return d.name;
                })
                .filter(function(d) { return d.x < width / 2; })
                .attr("x", 6 + topicEvolutionDiagram.nodeWidth())
                .attr("text-anchor", "start");

        var link = svg.append("g").selectAll(".link")
                .data(topicData.links)
                .enter().append("path")
                .attr("class", "link")
                .attr("d", path)
                .style("stroke-width", function(d) { return 8; });

        var text = svg.selectAll(".linktext")
                                .data(topicData.links)
                                .enter()
                                .append("text");

        var textLabels = text
                         .attr("x", function(d) {
                                var dsource;
                                var dtarget;
                                topicEvolutionDiagram.nodes().forEach(function(node) {
                                    if(node.topicId == d.source){
                                        dsource=node;
                                    }
                                    if(node.topicId == d.target){
                                        dtarget=node;
                                    }
                                });
                                return (dsource.x + (dtarget.x - dsource.x) * 0.5);
                         })
                         .attr("y", function(d) {
                                var dsource;
                                var dtarget;
                                topicEvolutionDiagram.nodes().forEach(function(node) {
                                    if(node.topicId == d.source){
                                        dsource=node;
                                    }
                                    if(node.topicId == d.target){
                                        dtarget=node;
                                    }
                                });
                                return (dsource.y + (dtarget.y + dtarget.barHeight - dsource.y) * 0.5);
                         })
                         .text( function (d) {
                             return d.rankAgainstNextTopicInPreGroup + " : " + d.rankAgainstPreTopicInNextGroup;
                         })
                         .attr("font-family", "sans-serif")
                         .attr("font-size", "14px")
                         .attr("fill", "red");

        function dragmove(d) {
            d3.select(this).attr("transform", "translate(" + d.x + "," + (d.y = Math.max(0, Math.min(height - d.barHeight/2 - margin.bottom, d3.event.y))) + ")");
            topicEvolutionDiagram.relayout();
            link.attr("d", path);
        }
    });

</script>
<script>

    GoogleAnalyticsObject = "ga", ga = function() { ga.q.push(arguments); }, ga.q = [], ga.l = +new Date;
    ga("create", "UA-48272912-3", "ocks.org");
    ga("send", "pageview");

</script>
<script async src="//www.google-analytics.com/analytics.js"></script>

<!--
<script>
    $(document).ready(function() {


    });
</script>
-->

</body>

</html>

