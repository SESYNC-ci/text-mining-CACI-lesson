---
layout: default
style: /css/lesson.css
---

{% for sorted in site.slide_sorter %}
{% assign id = "/slides/" | append: sorted %}
{% assign slide = site.slides | where: "id", id | first %}
  
<a name="{{ id }}"></a>
  
{{ slide.content }}

[Top of Section](#{{ id }})
{:.ToS}
  
---
  
{% endfor %}
