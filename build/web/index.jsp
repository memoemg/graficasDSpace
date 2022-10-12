<%-- 
    Document   : graficos
    Created on : 23/06/2020, 09:29:00 AM
    Author     : guies
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Scanner"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Estadísticas DSpace</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vega@5"></script>
        <script src="https://cdn.jsdelivr.net/npm/vega-lite@4"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/vega-embed/6.10.0/vega-embed.js"></script>
    </head>
    <body>
        <div class="container">
            <div class="jumbotron">
                <!--<img src="https://repositorio.una.ac.cr/themes/Mirage2/images/unalogo-pie.png" class="float-right" alt="Logo RAI">-->
		<img src="http://10.0.96.79:8080/themes/Mirage2//images/unalogo-pie.png" class="float-right" alt="Logo RAI">
                <div class="row">
                    <div class="col-md-12">
                        <h1>Estadísticas del Respositorio Institucional</h1>
                        <h6>Los datos graficados corresponden en tiempo real con la información recogida en el RAI.</h6>
                        <br>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <p>Comunidad
                        <select id="comunidades" name="comunidades" class="form-control" onchange="community_change()">
                            <option value="" selected="selected"> - Elija una comunidad - </option>

                            <%
                                String dburl = "jdbc:postgresql://localhost/unarai";
                                String dbusername = "repousr";
                                String dbpassword = "desa_6479";

                                try {
                                    Class.forName("org.postgresql.Driver");
                                    Connection con = DriverManager.getConnection(dburl, dbusername, dbpassword);
                                    PreparedStatement pstmt = null;
                                    pstmt = con.prepareStatement("SELECT text_value as nombre, uuid as id FROM community, metadatavalue WHERE community.uuid = metadatavalue.dspace_object_id AND metadata_field_id = 64 ORDER by nombre");
                                    ResultSet rs = pstmt.executeQuery();
                                    while (rs.next()) {
                            %>
                            <option value="<%=rs.getString("id")%>">
                                <%=rs.getString("nombre")%>
                            </option>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();

                                }
                            %>
                        </select>
                    </p>
                </div>
                <div class="col-md-4">
                    <p>Colección
                        <select id="colecciones" name="colecciones" class="form-control">
                            <option selected="selected"> - Elija una colección - </option>
                        </select>
                    </p>
                </div>
                <div class="col-md-4">
                    <p><br><button id="enviar" type="submit" class="btn btn-danger">Graficar</button></p>
                </div>
            </div>
            <div id="graficos">
            </div>
        </div>

        <script type="text/javascript">
            function community_change()
            {
                var community_id = $('#comunidades').val();

                $.ajax({
                    type: "POST",
                    url: "colecciones.jsp",
                    data: {'id': community_id},
                    cache: false,
                    success: function (response)
                    {
                        $('#colecciones').html(response);
                    }
                });
            }

            $('#enviar').click(function () {

                var community_id = $('#comunidades').val();
                var collection_id = $('#colecciones').val();
                var url_types = "";
                var url_years = "";
                var url_languages = "";
                var url_procedences = "";
                var url_rights = "";

                if (community_id === "")
                {
                    url_types = "http://localhost:8080/solr/search/select?q=*%3A*&fq=search.resourcetype%3A+2&rows=0&wt=json&indent=true&facet=true&facet.field=bi_6_dis_value_filter";
                    url_years = "http://localhost:8080/solr/search/select?q=*%3A*&fq=search.resourcetype%3A+2&rows=0&wt=json&indent=true&facet=true&facet.field=dateIssued.year";
                    url_languages = "http://localhost:8080/solr/search/select?q=*%3A*&fq=search.resourcetype%3A+2&rows=0&wt=json&indent=true&facet=true&facet.field=dc.language.iso";
                    url_procedences = "http://localhost:8080/solr/search/select?q=*%3A*&fq=search.resourcetype%3A+2&rows=0&wt=json&indent=true&facet=true&facet.field=bi_5_dis_value_filter";
                    url_rights = "http://localhost:8080/solr/search/select?q=*%3A*&fq=search.resourcetype%3A+2&rows=0&wt=json&indent=true&facet=true&facet.field=bi_7_dis_value_filter";
                } else
                {
                    if (collection_id === "-1")
                    {
                        url_types = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.comm%3A+" + community_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=bi_6_dis_value_filter&f.bi_6_dis_value_filter.facet.mincount=1";
                        url_years = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.comm%3A+" + community_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=dateIssued.year&f.dateIssued.year.facet.mincount=1";
                        url_languages = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.comm%3A+" + community_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=dc.language.iso&f.dc.language.iso.facet.mincount=1";
                        url_procedences = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.comm%3A+" + community_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=bi_5_dis_value_filter&f.bi_5_dis_value_filter.facet.mincount=1";
                        url_rights = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.comm%3A+" + community_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=bi_7_dis_value_filter&f.bi_7_dis_value_filter.facet.mincount=1";
                    } else
                    {
                        url_types = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.coll%3A+" + collection_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=bi_6_dis_value_filter&f.bi_6_dis_value_filter.facet.mincount=1";
                        url_years = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.coll%3A+" + collection_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=dateIssued.year&f.dateIssued.year.facet.mincount=1";
                        url_languages = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.coll%3A+" + collection_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=dc.language.iso&f.dc.language.iso.facet.mincount=1";
                        url_procedences = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.coll%3A+" + collection_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=bi_5_dis_value_filter&f.bi_5_dis_value_filter.facet.mincount=1";
                        url_rights = "http://localhost:8080/solr/search/select?q=*%3A*&fq=location.coll%3A+" + collection_id + "&rows=0&wt=json&indent=true&facet=true&facet.field=bi_7_dis_value_filter&f.bi_7_dis_value_filter.facet.mincount=1";
                    }
                }


                $.ajax({
                    type: "POST",
                    url: "proxy.jsp",
                    data: {'url_types': url_types,
                        'url_years': url_years,
                        'url_languages': url_languages,
                        'url_procedences': url_procedences,
                        'url_rights': url_rights},
                    cache: false,
                    success: function (response)
                    {
                        $('#graficos').html(response);
                    }
                });
            });

        </script>
    </body>
</html>