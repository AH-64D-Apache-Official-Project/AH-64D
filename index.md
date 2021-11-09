---
title: "AH-64 Project Documentation"
tags: [getting_started]
sidebar: ah64d_sidebar
permalink: index.html
---

Welcome to the Arma 3 AH-64D Apache mod documentation

This is a central source of information about the aircraft and its operation.

If would like to contribute some of your time to help us with this work then please contact `mattysmith22` on our discord.

{% for folder in site.data.sidebars.ah64d_sidebar.entries[0].folders %}
  <h2>{{folder.title}}</h2>

  <ul>
  {% for folderitem in folder.folderitems %}
    <li><a href="{{folderitem.url}}">{{folderitem.title}}</a></li>
  {% endfor %}
  </ul>
{% endfor %}