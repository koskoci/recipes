select id, data
from recipes, jsonb_array_elements_text(data -> 'ingredients')
where value ilike '%poire%'
and id in (
  select id
  from recipes, jsonb_array_elements_text(data -> 'ingredients')
  where value ilike '%oeuf%'
  limit 2
)
and id in (
  select id
  from recipes, jsonb_array_elements_text(data -> 'ingredients')
  where value ilike '%veau%'
  limit 2
);

