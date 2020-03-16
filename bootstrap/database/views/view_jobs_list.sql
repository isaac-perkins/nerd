-- View: public.view_jobs_list

-- DROP VIEW public.view_jobs_list;

CREATE OR REPLACE VIEW public.view_jobs_list AS 
 SELECT j.id,
    j.owner_id,
    j.type_id,
    j.title,
    j.description,
    j.started,
    j.ended,
    j.locate,
    j.status,
    j.created_at,
    j.updated_at,
    l2.url AS public_url,
    l2.id AS link_id,
    ( SELECT COALESCE(sum(l_1.labels), 0::bigint) AS sum
           FROM training l_1
          WHERE l_1.job_id = j.id) AS labels,
    ( SELECT count(l3.id) AS count
           FROM training l3
          WHERE l3.job_id = j.id) AS link_count
   FROM jobs j
     LEFT JOIN ( SELECT DISTINCT max(training.id) AS id,
            training.job_id
           FROM training
          GROUP BY training.job_id) l ON j.id = l.job_id
     LEFT JOIN training l2 ON l.id = l2.id
    

