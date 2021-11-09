---
title: "Keybinds"
tags: [getting_started]
sidebar: ah64d_sidebar
permalink: keybinds.html
stub: true
---

This mod adds a lot of custom controls that you can bind. What you may find though, is that not all of them are essential. Many of them are useful only to give you fast access to the control if you need it.

It is recommended at first to not set up these these controls, and instead gain practice with the mod first and as you start to want quicker access to more controls, add them then.

To see how to map controls, see our page on [Setting Up](setup)

{% capture check %}<i class="fa fa-check text-success"></i>{% endcapture %}
{% capture cross %}<i class="fa fa-times text-danger"></i>{% endcapture %}

{% capture offset_keybinds_raw %}
    (noCategory){% for keybind in site.data.keybinds %}|{{keybind[1].category}}{% endfor %}
{% endcapture %}
{% assign offset_keybinds = offset_keybinds_raw | split: "|" %}

<table>
<thead>
    <tr>
        <td>Control</td>
        <td>Keybind</td>
        <td>Description</td>
    </tr>
</thead>
<tbody>
{% for keybind in site.data.keybinds %}
{% assign key = keybind[0]%}
{% if offset_keybinds[forloop.index0] != keybind[1].category %}
    <tr><td colspan="4" style="text-align:center"><b>{{keybind[1].category}}</b></td></tr>
{% endif %}
<tr id="{{keybind[0]}}">
    <td>{{keybind[1].name}}</td>
    <td>{% include keybind.html name=key html=true%}</td>
    <td>{{keybind[1].description}}</td>
</tr>
{% endfor %}
</tbody>
</table>