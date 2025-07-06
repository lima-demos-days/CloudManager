# Spokes

Gestión centralizada de los _spokes_ por parte del hub (Manager-Cluster). Tiene tres tipos de directorios:

* `.businessflow-repo`: sincroniza el repositorio de un flujo de negocio (e.g, Inversiones, CuentasBancarias, etc) con el spoke a través del `GitRepository` de Flux. También, relaciona e importa los CRDs definidos en `platform-engineering` y `seguridad` en el spoke repo.
* `.cloud-native`: gestiona la instalación centralizada de paquetes en los spokes via Helm-Charts. Instala distribuciones como Flux, Crossplane, Istio, etc.
* `.config`: establece los procesos de instalación, configuración y adecuación de los clústers de los spokes a través del Helm Provider.
* `<spoke-app>`: se refiere a un cluster de negocio específico (e.g, Inversiones-Cluster, CuentaBancaria-Cluster, etc). Adiciona el flujo de negocio al hub y relaciona los protocolos administrativos del spoke (Namespaces y RBAC).