apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: web
  name: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - image: ${web_image_uri}
          name: web
          ports:
            - containerPort: 5000
      restartPolicy: Always

      
---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: web
  name: web
spec:
  ports:
    - name: "5000"
      port: 5000
      targetPort: 5000
  selector:
    app: web
