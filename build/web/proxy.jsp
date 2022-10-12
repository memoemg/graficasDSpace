<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>

    <body>

        <%@page contentType="text/html" pageEncoding="UTF-8"%>
        <%@page import="java.io.BufferedReader"%>
        <%@page import="java.io.IOException"%>
        <%@page import="java.io.InputStream"%>
        <%@page import="java.io.InputStreamReader"%>
        <%@page import="java.io.Reader"%>
        <%@page import="java.net.URL"%>
        <%@page import="java.nio.charset.Charset"%>
        <%@page import="org.json.JSONException"%>
        <%@page import="org.json.JSONObject"%>
        <%@page import="org.json.JSONArray"%>

        <%!
            public class JsonReader {

                private String readAll(Reader rd) throws IOException {
                    StringBuilder sb = new StringBuilder();
                    int cp;
                    while ((cp = rd.read()) != -1) {
                        sb.append((char) cp);
                    }
                    return sb.toString();
                }

                public JSONObject readJsonFromUrl(String url) throws IOException, JSONException {
                    InputStream is = new URL(url).openStream();
                    try {
                        BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
                        String jsonText = readAll(rd);
                        JSONObject json = new JSONObject(jsonText);
                        return json;
                    } finally {
                        is.close();
                    }
                }

                public JSONArray sort(JSONArray desordenado) {

                    JSONArray ordenado = new JSONArray();
                    JSONObject nuevo;
                    int suma = 0;
                    boolean found = false;

                    for (int i = 0; i < desordenado.length(); i++) {

                        for (int j = i + 1; j < desordenado.length(); j++) {

                            try {
                                if (desordenado.getJSONObject(j).getString("value").equals(desordenado.getJSONObject(i).getString("value"))) {
                                    suma = desordenado.getJSONObject(j).getInt("count") + desordenado.getJSONObject(i).getInt("count");
                                    desordenado.remove(j);
                                    found = true;
                                }

                            } catch (Exception e) {}
                        }

                        if (found) {
                        //meto el nuevo
                            try
                            {
                                nuevo  = new JSONObject();
                                nuevo.put("count", suma);
                                nuevo.put("value", desordenado.getJSONObject(i).getString("value"));
                                ordenado.put(nuevo);
                            }catch (Exception e) {}
                        } else {
                        //meto el original
                            try
                            {
                                ordenado.put(desordenado.getJSONObject(i));
                            }catch (Exception e) {}
                        }

                        found = false;
                        suma = 0;
                    }

                    return ordenado;

                }

                public JSONObject transformToVega(JSONObject original, String nombreGrafico) {

                    JSONObject nuevo = new JSONObject();
                    JSONArray vector = new JSONArray();
                    JSONArray array = new JSONArray();

                    try {

                        JSONObject facetCounts = (JSONObject) original.get("facet_counts");
                        JSONObject facetFields = (JSONObject) facetCounts.get("facet_fields");

                        switch (nombreGrafico) {
                            case "tipos":
                                vector = facetFields.getJSONArray("bi_6_dis_value_filter");
                                break;

                            case "idiomas":
                                vector = facetFields.getJSONArray("dc.language.iso");
                                break;

                            case "fechas":
                                vector = facetFields.getJSONArray("dateIssued.year");
                                break;

                            case "procedencias":
                                vector = facetFields.getJSONArray("bi_5_dis_value_filter");
                                break;

                            case "derechos":
                                vector = facetFields.getJSONArray("bi_7_dis_value_filter");
                                break;
                        }

                        for (int i = 0; i < vector.length() - 1; i++) {

                            JSONObject item = new JSONObject();

                            switch (nombreGrafico) {

                                case "tipos":

                                    String valor = vector.get(i).toString();

                                    switch (valor) {

                                        case "http://purl.org/coar/resource_type/c_2cd9":
                                            item.put("value", "Revista divulgativa");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_7a1f":
                                            item.put("value", "Proyecto fin de carrera");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_6501":
                                            item.put("value", "Artículo científico");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_bdcc":
                                            item.put("value", "Tesis de maestría");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_8042":
                                            item.put("value", "Documento de trabajo");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_1843":
                                            item.put("value", "Otro");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_5794":
                                            item.put("value", "Comunicación de congreso");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_db06":
                                            item.put("value", "Tesis doctoral");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_998f":
                                            item.put("value", "Artículo de períodico");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_26e4":
                                            item.put("value", "Entrevista");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_6670":
                                            item.put("value", "Póster de congreso");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_8544":
                                            item.put("value", "Ponencia");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_93fc":
                                            item.put("value", "Informe");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_3248":
                                            item.put("value", "Capítulo de libro");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_816b":
                                            item.put("value", "Artículo preliminar");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_18wq":
                                            item.put("value", "Otro tipo de informe");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_12cd":
                                            item.put("value", "Mapa");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_ba08":
                                            item.put("value", "Reseña de libro");
                                            break;

                                        case "http://purl.org/coar/resource_type/c_12ce":
                                            item.put("value", "Vídeo");
                                            break;

                                        default:
                                            item.put("value", vector.get(i));
                                            break;
                                    }

                                    item.put("count", vector.get(i + 1));
                                    array.put(item);
                                    break;

                                case "derechos":

                                    if (vector.get(i).equals("Acceso abierto")) {
                                        item.put("value", vector.get(i));
                                        item.put("count", vector.get(i + 1));
                                        array.put(item);
                                    } else {
                                        if (vector.get(i).equals("Acceso cerrado")) {
                                            item.put("value", vector.get(i));
                                            item.put("count", vector.get(i + 1));
                                            array.put(item);
                                        } else {

                                            if (vector.get(i).equals("Acceso restringido")) {
                                                item.put("value", vector.get(i));
                                                item.put("count", vector.get(i + 1));
                                                array.put(item);
                                            } else {

                                                if (vector.get(i).equals("Acceso embargado")) {
                                                    item.put("value", vector.get(i));
                                                    item.put("count", vector.get(i + 1));
                                                    array.put(item);
                                                } else {
                                                    //no se hace nada
                                                }
                                            }
                                        }
                                    }
                                    break;

                                default:
                                    item.put("value", vector.get(i));
                                    item.put("count", vector.get(i + 1));
                                    array.put(item);
                                    break;

                            }

                            i++;

                        }

                        nuevo.put(nombreGrafico, sort(array));
                        return nuevo;

                    } catch (Exception e) {
                        System.err.print(e.getMessage());
                    }
                    return nuevo;
                }

            }

        %>

        <script>
            function formatPlot(data) {

                var vlSpec = {
                    "width": 755,
                    "padding": 15,
                    "autosize": "pad",
                    "$schema": "https://vega.github.io/schema/vega-lite/v4.json",
                    "data": {
                        "values": data.tipos
                    },
                    "height": {"step": 50},
                    "mark": {"type": "bar", "yOffset": 5, "cornerRadiusEnd": 2, "color": "#22304D"},
                    "encoding": {
                        "y": {
                            "field": "value",
                            "type": "nominal",
                            "scale": {"padding": 0},
                            "band": 0.5,
                            "sort": "-x",
                            "title": null,
                            "axis": {
                                "bandPosition": 0,
                                "grid": true,
                                "domain": false,
                                "ticks": false,
                                "labelAlign": "left",
                                "labelBaseline": "middle",
                                "labelPadding": -5,
                                "labelOffset": -15,
                                "labelLimit": 250,
                                "titleX": 5,
                                "titleY": -5,
                                "titleAngle": 0,
                                "titleAlign": "left"
                            }
                        },
                        "x": {
                            "field": "count",
                            "type": "quantitative",
                            "axis": {
                                "title": null,
                                "orient": "top",
                                "grid": false
                            },
                            "scale": {"type": "sqrt"}
                        },
                        "tooltip": {"field": "count", "type": "quantitative"}
                    }
                };
                vegaEmbed('#vis', vlSpec);
            }


            function yearPlot(data) {

                var vlSpec = {
                    "width": 755,
                    "height": 470,
                    "padding": 15,
                    "autosize": "pad",
                    "$schema": "https://vega.github.io/schema/vega-lite/v4.json",
                    "data": {
                        "values": data.fechas
                    },
                    "mark": {"type": "bar", "color": "#cc071e"},
                    "encoding": {
                        "x": {
                            "field": "value",
                            "type": "nominal",
                            "title": null
                        },
                        "y": {
                            "field": "count",
                            "type": "quantitative",
                            "title": null
                        },
                        "tooltip": {
                            "field": "count",
                            "type": "quantitative"
                        }
                    }
                };
                vegaEmbed('#vis2', vlSpec);
            }


            function languagePlot(data) {

                var vlSpec = {
                    "width": 655,
                    "height": 370,
                    "padding": 15,
                    "autosize": "pad",
                    "$schema": "https://vega.github.io/schema/vega-lite/v4.json",
                    "data": {
                        "values": data.idiomas
                    },
                    "mark": {"type": "arc", "innerRadius": 150},
                    "encoding": {
                        "theta": {"field": "count", "type": "quantitative"},
                        "color": {
                            "field": "value",
                            "type": "nominal",
                            "legend": {"title": "Idioma"}
                        },
                        "tooltip": {"field": "count", "type": "quantitative"}
                    },
                    "view": {"stroke": null}
                };
                vegaEmbed('#vis3', vlSpec);
            }


            function procedencePlot(data) {

                var vlSpec = {
                    "width": 755,
                    "padding": 15,
                    "autosize": "pad",
                    "$schema": "https://vega.github.io/schema/vega-lite/v4.json",
                    "data": {
                        "values": data.procedencias
                    },
                    "height": {"step": 50},
                    "mark": {"type": "bar", "yOffset": 5, "cornerRadiusEnd": 2, "color": "#C77272"},
                    "encoding": {
                        "y": {
                            "field": "value",
                            "type": "nominal",
                            "scale": {"padding": 0},
                            "band": 0.5,
                            "sort": "-x",
                            "title": null,
                            "axis": {
                                "bandPosition": 0,
                                "grid": true,
                                "domain": false,
                                "ticks": false,
                                "labelAlign": "left",
                                "labelBaseline": "middle",
                                "labelPadding": -5,
                                "labelOffset": -15,
                                "labelLimit": 550,
                                "titleX": 5,
                                "titleY": -5,
                                "titleAngle": 0,
                                "titleAlign": "left"
                            }
                        },
                        "x": {
                            "field": "count",
                            "type": "quantitative",
                            "axis": {
                                "title": null,
                                "orient": "top",
                                "grid": false
                            },
                            "scale": {"type": "sqrt"}
                        },
                        "tooltip": {"field": "count", "type": "quantitative"}
                    }
                };
                vegaEmbed('#vis4', vlSpec);
            }

            function accessLevelPlot(data) {

                var vlSpec = {
                    "width": 755,
                    "height": 470,
                    "padding": 15,
                    "autosize": "pad",
                    "$schema": "https://vega.github.io/schema/vega-lite/v4.json",
                    "data": {
                        "values": data.derechos
                    },
                    "mark": {
                        "type": "bar"
                    },
                    "encoding": {
                        "x": {
                            "field": 'value',
                            "type": "nominal",
                            "title": null,
                            "sort": "-y"
                        },
                        "y": {
                            "field": 'count',
                            "type": "quantitative",
                            "title": null
                        },
                        "tooltip": {"field": 'count', "type": "quantitative"},
                        "color": {
                            "field": 'value',
                            "type": "nominal",
                            "legend": {
                                "title": "Nivel de acceso"
                            }
                        }
                    }
                };
                vegaEmbed('#vis5', vlSpec);
            }


        </script>


        <%
            String urlResourceType = request.getParameter("url_types");
            String urlYear = request.getParameter("url_years");
            String urlLanguage = request.getParameter("url_languages");
            String urlProcedence = request.getParameter("url_procedences");
            String urlRights = request.getParameter("url_rights");

            JsonReader vamoalee = new JsonReader();

            JSONObject json = vamoalee.readJsonFromUrl(urlResourceType);
            JSONObject jsonYear = vamoalee.readJsonFromUrl(urlYear);
            JSONObject jsonLanguage = vamoalee.readJsonFromUrl(urlLanguage);
            JSONObject jsonProcedences = vamoalee.readJsonFromUrl(urlProcedence);
            JSONObject jsonRights = vamoalee.readJsonFromUrl(urlRights);

            JSONObject nodo1 = (JSONObject) json.get("response");

            JSONObject nuevoTypes = vamoalee.transformToVega(json, "tipos");
            JSONObject nuevoYears = vamoalee.transformToVega(jsonYear, "fechas");
            JSONObject nuevoLanguages = vamoalee.transformToVega(jsonLanguage, "idiomas");
            JSONObject nuevoProcedences = vamoalee.transformToVega(jsonProcedences, "procedencias");
            JSONObject nuevoRights = vamoalee.transformToVega(jsonRights, "derechos");
            
            String queHay = nuevoTypes.toString();

        %>

        <!-- Nav tabs -->
        <ul class="nav nav-tabs" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" data-toggle="tab" href="#tipo" style="color: #C01A2C;">Tipo documental</a>               
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="tab" href="#fecha" style="color: #C01A2C;">Año de publicación</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="tab" href="#idioma" style="color: #C01A2C;">Idioma</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="tab" href="#procedencia" style="color: #C01A2C;">Unidad de procedencia</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="tab" href="#acceso" style="color: #C01A2C;">Nivel de acceso</a>
            </li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            <div id="tipo" class="container tab-pane active"><br>
                Cantidad de documentos: <%=nodo1.getInt("numFound")%><br>
                 <!--El array: <%=queHay%><br>-->
                <div id="vis"></div>
            </div>
            <div id="fecha" class="container tab-pane fade"><br>
                Cantidad de documentos: <%=nodo1.getInt("numFound")%><br>
                <div id="vis2"></div>
            </div>
            <div id="idioma" class="container tab-pane fade"><br>
                Cantidad de documentos: <%=nodo1.getInt("numFound")%><br>
                <div id="vis3"></div>
            </div>
            <div id="procedencia" class="container tab-pane fade"><br>
                Cantidad de documentos: <%=nodo1.getInt("numFound")%><br>
                <div id="vis4"></div>
            </div>
            <div id="acceso" class="container tab-pane fade"><br>
                Cantidad de documentos: <%=nodo1.getInt("numFound")%><br>
                <div id="vis5"></div>
            </div>
        </div>

        <script>
            formatPlot(<%=nuevoTypes%>);
            yearPlot(<%=nuevoYears%>);
            languagePlot(<%=nuevoLanguages%>);
            procedencePlot(<%=nuevoProcedences%>);
            accessLevelPlot(<%=nuevoRights%>);
        </script>

    </body>

</html>
