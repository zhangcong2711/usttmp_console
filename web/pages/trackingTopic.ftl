
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
            height: ${(basicHeight+50)?c}px;
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

<div id="wrapper" style="width: ${(basicWidth)?c}px; height: ${(basicHeight+50)?c}px">

    <div class="row" style="width:100%">
        <div class="panel panel-default" style="width:100%;height: 100%">
            <div class="panel-heading" style="width:100%;height: 100%">
                Topic Tracking: ${task.name}   Mining Interval: ${task.miningInterval}   Alpha: ${task.alpha}   Beta: ${task.beta}
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body" style="width:100%;height: 100%">
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

<script src="/${webRootPath}/resources/topicEvolution/jquery-tagcloud/jquery.tagcloud.js"></script>
<script>

    var tagCloudArr={};

    var margin = {top: 1, right: 1, bottom: 6, left: 1},
            chartWidth = ${(basicWidth)?c} - margin.left - margin.right,
            chartHeight = ${basicHeight?c} - margin.top - margin.bottom;

    var formatNumber = d3.format(",.0f"),
            format = function(d) { return formatNumber(d) + " TWh"; },
            color = d3.scale.category20();

    var svg = d3.select("#chart").append("svg")
            .attr("width", chartWidth + margin.left + margin.right)
            .attr("height", chartHeight + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var topicEvolutionDiagram = d3.topicEvolutionDiagram()
            .topicNum(${topicNum?c})
            .nodeWidth(20)
            .nodePadding(5)
            .size([chartWidth, chartHeight]);

    var path = topicEvolutionDiagram.link();

    d3.json("ajax/getTopicDataByTaskId?taskId=${task.id}", function(topicData) {

//        topicData.labels=[];

        topicEvolutionDiagram
                .nodes(topicData.nodes)
                .links(topicData.links)
                .labels(topicData.labels)
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
                        .on("drag", dragmove))
                .on("dblclick", nodeOnClick);

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
                .filter(function(d) { return d.x < chartWidth / 2; })
                .attr("x", 6 + topicEvolutionDiagram.nodeWidth())
                .attr("text-anchor", "start");

        var labels = svg.selectAll(".text")
                .data(topicData.labels)
                .enter();

        labels.append("text")
                .attr("x", function(d) { return d.x+1; })
                .attr("y", function(d) { return d.y; })
                .attr("dy", ".35em")
                .attr("text-anchor", "start")
                .attr("transform", null)
                .style("font-size", "14px")
                .style("font-weight", "bold")
                .text(function(d) {
                    return d.name;
                });

        var link = svg.append("g").selectAll(".link")
                .data(topicData.links)
                .enter().append("path")
                .attr("class", "link")
                .attr("d", path)
                .style("stroke-width", function(d) { return 8; });

        /*
        var rankText = svg.selectAll(".linktext")
                                .data(topicData.links)
                                .enter()
                                .append("text");

        var rankTextLabels = rankText
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
        */

        function dragmove(d) {
            d3.select(this).attr("transform", "translate(" + d.x + "," + (d.y = Math.max(0, Math.min(chartHeight, d3.event.y))) + ")");
            topicEvolutionDiagram.relayout();
            link.attr("d", path);

            var divname="topicTagCloud_" + d.topicId;
            if(null!=tagCloudArr[divname]){
                var tagDiv=tagCloudArr[divname];
                tagDiv.style('display','none');
            }
        }
    });

    function nodeOnClick(node) {

        var divname="topicTagCloud_" + node.topicId;

        if(null!=tagCloudArr[divname]){
            var tagDiv=tagCloudArr[divname];
            if(tagDiv.style('display')=='none'){
                var dTop=$("#chart")[0].offsetTop;
                var dLeft=$("#chart")[0].offsetLeft;
                tagDiv
                        .style('display','block')
                        .style("left", (dLeft + node.x + topicEvolutionDiagram.nodeWidth() + 10 + "px"))
                        .style("top", (dTop + node.y + 5 +"px"));
            }else{
                tagDiv
                        .style('display','none');
            }

        }else{

            var wpstr = node.normalizedWordProbabilitys;
            var wparr = wpstr.split(",");
            shuffleArray(wparr);

            var innerHtml="";

            wparr.forEach(function (element, index, array) {
                var word = ((element.trim()).split(":"))[0];
                var probabiblity = ((element.trim()).split(":"))[1];

                innerHtml += '<a rel="'+probabiblity+'">'+word+'&nbsp;&nbsp;</a>';

                if(0!=index && array.length!=index && 0==((index+1)%5)){
                    innerHtml += '<br/>';
                }
            });

            /*
            var innerHtml='<a rel="7">peace</a>'+
                    '<a rel="3">ytr</a>'+
                    '<a rel="10">werwe</a>'+
                    '<a rel="3">wr</a>'+
                    '<a rel="10">kjhgj</a>'+
                    '<a rel="3">rtfe</a><br/>'+
                    '<a rel="10">sffzz</a>'+
                    '<a rel="3">unity</a>'+
                    '<a rel="10">love</a>'+
                    '<a rel="5">having fun</a>';*/

            var dTop=$("#chart")[0].offsetTop;
            var dLeft=$("#chart")[0].offsetLeft;

            var g = d3.select(this); // The node
            var div = d3.select("body").append("div")
                    .attr('id', divname)
                    .attr('pointer-events', 'none')
                    .attr("class", "tooltip")
                    .style("opacity", 0.9)
                    .style('display','block')
                    .style('background-color','white')
                    .style('border','1px solid')
                    .style('border-radius','10px')
                    .html(innerHtml)
                    .style("left", (dLeft + node.x + topicEvolutionDiagram.nodeWidth() + 10 + "px"))
                    .style("top", (dTop + node.y + 5 +"px"));

            $('#'+divname+' a').tagcloud();

            tagCloudArr[divname]=div;
        }
    }

    function shuffleArray(a) { // Fisher-Yates shuffle, no side effects
        var i = a.length, t, j;
        a = a.slice();
        while (--i) t = a[i], a[i] = a[j = ~~(Math.random() * (i+1))], a[j] = t;
        return a;
    }


    //Tag Cloud
    $.fn.tagcloud.defaults = {
        size: {start: 10, end: 20, unit: 'pt'},
        color: {start: '#87CEFA', end: '#191970'}
    };

</script>
<!--<script>-->

    <!--GoogleAnalyticsObject = "ga", ga = function() { ga.q.push(arguments); }, ga.q = [], ga.l = +new Date;-->
    <!--ga("create", "UA-48272912-3", "ocks.org");-->
    <!--ga("send", "pageview");-->

<!--</script>-->
<!--<script async src="//www.google-analytics.com/analytics.js"></script>-->

<!--
<script>
    $(document).ready(function() {


    });
</script>
-->

</body>

</html>

