---
sidebar_position: 6
---

# Limitations

While Newton allows for a considerable number of particles, adding an excessive amount can impact performance and result in frame jank, especially when using physics-based particles. Computing particle interactions can be resource-intensive, which reduces the maximum number of particles before performance degradation occurs.

Additionally, some effects, such as smoke, are currently not available in the physics-based configuration due to the lack of buoyancy effects. Buoyancy will be implemented in later versions, allowing for more advanced particle behavior in physics simulations.

To maintain smooth animations, be mindful of the particle count, especially in scenarios where physics interactions are involved. Reducing the number of particles or optimizing their behavior can help in keeping performance stable.

Stay tuned for updates and improvements!