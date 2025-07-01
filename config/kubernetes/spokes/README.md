# Spokes

Gestión centralizada de los _spokes_ por parte del hub (Manager-Cluster). Tiene tres tipos de directorios:

* `cloud-native`: gestiona la instalación centralizada de paquetes en los spokes via Helm-Charts. Instala distribuciones como Flux, Crossplane, Istio, etc.
* `businessflow-repo`: sincroniza el repositorio de un flujo negocio (e.g, Inversiones, CuentasBancarias, etc) con el hub (Manager-Cluster).
* `<spoke-dir>`: se refiere a un cluster de negocio específico (e.g, Inversiones-Cluster, CuentaBancaria-Cluster, etc). Adiciona el flujo de negocio al hub y, a su vez, relaciona los microservicios individuales con el spoke.