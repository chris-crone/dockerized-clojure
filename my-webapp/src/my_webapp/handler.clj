(ns my-webapp.handler
  (:require [my-webapp.views :as views]
            [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.adapter.jetty :as jetty] ; add this require
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]])
  (:gen-class)) ; and add this gen-class

(defroutes app-routes ; replace the generated app-routes with this
  (GET "/"
       []
       (views/home-page))
  (GET "/add-location"
       []
       (views/add-location-page))
  (POST "/add-location"
        {params :params}
        (views/add-location-results-page params))
  (GET "/location/:loc-id"
       [loc-id]
       (views/location-page loc-id))
  (GET "/all-locations"
       []
       (views/all-locations-page))
  (route/resources "/")
  (route/not-found "Not Found"))

(def app
  (wrap-defaults app-routes site-defaults))

(defn -main
  [& [port]]
  (let [port (Integer. (or port
                           (System/getenv "PORT")
                           5000))]
    (jetty/run-jetty #'app {:port  port
                            :join? false})))
