
<%@page import="java.net.URI"%>
<%@page import="java.util.Collections"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.HttpURLConnection"%>


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
        <%@page import="java.util.ArrayList"%>

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

                            } catch (Exception e) {
                            }
                        }

                        if (found) {
                            //meto el nuevo
                            try {
                                nuevo = new JSONObject();
                                nuevo.put("count", suma);
                                nuevo.put("value", desordenado.getJSONObject(i).getString("value"));
                                ordenado.put(nuevo);
                            } catch (Exception e) {
                            }
                        } else {
                            //meto el original
                            try {
                                ordenado.put(desordenado.getJSONObject(i));
                            } catch (Exception e) {
                            }
                        }

                        found = false;
                        suma = 0;
                    }

                    return ordenado;

                }

                public JSONObject transformToVega(JSONObject original) {

                    JSONObject nuevo = new JSONObject();
                    JSONArray vector = new JSONArray();
                    JSONArray array = new JSONArray();

                    try {

                        JSONObject facetCounts = (JSONObject) original.get("facet_counts");
                        JSONObject facetFields = (JSONObject) facetCounts.get("facet_fields");

                        vector = facetFields.getJSONArray("bi_6_dis_value_filter");

                        for (int i = 0; i < vector.length() - 1; i++) {

                            JSONObject item = new JSONObject();

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
                            i++;

                        }

                        nuevo.put("tipos", sort(array));
                        return nuevo;

                    } catch (Exception e) {
                        System.err.print(e.getMessage());
                    }
                    return nuevo;
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
                    "mark": {"type": "bar", "yOffset": 5, "cornerRadiusEnd": 2, "color": "#2B6B90"},
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
                vegaEmbed('#vis6', vlSpec);
            }

        </script>

        <%

            String urlMultiple = request.getParameter("multiple_url");
            //boolean containsProcedence = request.getParameter("procedence").equals("1");
            JsonReader vamoalee = new JsonReader();
            JSONObject json = vamoalee.readJsonFromUrl(urlMultiple);
            JSONObject nodo1 = (JSONObject) json.get("response");
            JSONObject nuevoTypes = vamoalee.transformToVega(json);

        %>

        <div>
            Cantidad de documentos: <%=nodo1.getInt("numFound")%><br>
            <div id="vis6"></div>
            <script>
                formatPlot(<%=nuevoTypes%>);
            </script>
        </div>

    </body>

</html>
