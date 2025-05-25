# cap-vapor deply


deploy:
	swift package --swift-sdk x86_64-swift-linux-musl \
        build-container-image --from swift:slim \
	    --username wildthink \
	    --default-registry ghcr.io --repository /wildthink/cap-vapor

