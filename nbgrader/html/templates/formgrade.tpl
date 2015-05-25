{%- extends 'basic.tpl' -%}
{% from 'mathjax.tpl' import mathjax %}
{% from 'formgrade_macros.tpl' import nav, header %}

{%- block header -%}
<!DOCTYPE html>
<html>
<head>
{{ header(resources) }}

{% for css in resources.inlining.css -%}
    <style type="text/css">
    {{ css }}
    </style>
{% endfor %}

<!-- Loading mathjax macro -->
{{ mathjax() }}

<link rel="stylesheet" href="{{resources.base_url}}/static/css/formgrade.css" />
{%- endblock header -%}

{% block body %}
<body>
  {{ nav(resources) }}
  <div class="container">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h4 class="panel-title">
          <span>{{ resources.notebook_id }}</span>
          <span class="pull-right">Submission {{ resources.index + 1 }} / {{ resources.total }}</span>
        </h4>
      </div>
      <div class="panel-body">
        <div id="notebook" class="border-box-sizing">
          <div class="container" id="notebook-container">
            {{ super() }}
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
{%- endblock body %}

{% block footer %}
</html>
{% endblock footer %}

{% macro score(cell) -%}
  <span id="{{ cell.metadata.nbgrader.grade_id }}-saved" class="glyphicon glyphicon-ok save-icon score-saved"></span>
  <div class="pull-right">
    <span class="btn-group btn-group-sm scoring-buttons" role="group">
      <button type="button" class="btn btn-success" id="{{ cell.metadata.nbgrader.grade_id }}-full-credit">Full credit</button>
      <button type="button" class="btn btn-danger" id="{{ cell.metadata.nbgrader.grade_id }}-no-credit">No credit</button>
    </span>
    <span>
      <input class="score" id="{{ cell.metadata.nbgrader.grade_id }}" style="width: 4em;" type="number" /> / {{ cell.metadata.nbgrader.points | float | round(2) }}
    </span>
  </div>
{%- endmacro %}


{% macro nbgrader_heading(cell) -%}
<div class="panel-heading">
{%- if cell.metadata.nbgrader.solution -%}
  <span class="nbgrader-label">Student's answer</span>
  <span class="glyphicon glyphicon-ok comment-saved save-icon"></span>
  {%- if cell.metadata.nbgrader.grade -%}
  {{ score(cell) }}
  {%- endif -%}
{%- elif cell.metadata.nbgrader.grade -%}
  <span class="nbgrader-label"><code>{{ cell.metadata.nbgrader.grade_id }}</code></span>
  {{ score(cell) }}
{%- endif -%}
</div>  
{%- endmacro %}

{% macro nbgrader_footer(cell) -%}
{%- if cell.metadata.nbgrader.solution -%}
<div class="panel-footer">
  <div><textarea class="comment" placeholder="Comments"></textarea></div>
</div>
{%- endif -%}
{%- endmacro %}

{% block markdowncell scoped %}
<div class="cell border-box-sizing text_cell rendered">
  {{ self.empty_in_prompt() }}

  {%- if 'nbgrader' in cell.metadata and (cell.metadata.nbgrader.solution or cell.metadata.nbgrader.grade) -%}
  <div class="panel panel-primary nbgrader_cell">
    {{ nbgrader_heading(cell) }}
    <div class="panel-body">
      <div class="text_cell_render border-box-sizing rendered_html">
        {{ cell.source  | markdown2html | strip_files_prefix }}
      </div>
    </div>
    {{ nbgrader_footer(cell) }}
  </div>

  {%- else -%}

  <div class="inner_cell">
    <div class="text_cell_render border-box-sizing rendered_html">
      {{ cell.source  | markdown2html | strip_files_prefix }}
    </div>
  </div>

  {%- endif -%}

</div>
{% endblock markdowncell %}

{% block input %}
  {%- if 'nbgrader' in cell.metadata and (cell.metadata.nbgrader.solution or cell.metadata.nbgrader.grade) -%}
  <div class="panel panel-primary nbgrader_cell">
    {{ nbgrader_heading(cell) }}
    <div class="panel-body">
      <div class="input_area">
        {{ cell.source | highlight_code(metadata=cell.metadata) }}
      </div>
    </div>
    {{ nbgrader_footer(cell) }}
  </div>

  {%- else -%}
  
  <div class="inner_cell">
    <div class="input_area">
      {{ cell.source | highlight_code(metadata=cell.metadata) }}
    </div>
  </div>
  {%- endif -%}

{% endblock input %}
