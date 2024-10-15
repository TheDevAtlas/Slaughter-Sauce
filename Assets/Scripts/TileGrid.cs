using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileGrid : MonoBehaviour
{
    public int gridX = 10; // Number of tiles along X axis
    public int gridZ = 10; // Number of tiles along Z axis
    public float tileSize = 1f; // Size of each tile
    public float spawnRadius = 10f; // Radius for circular spawn effect
    public float animationTime = 2f; // Time for tiles to float up
    public AnimationCurve heightCurve; // Animation curve for the floating effect
    public GameObject tilePrefab; // Prefab for the tile
    public Gradient colorGradient; // Gradient for colors

    private List<GameObject> tiles = new List<GameObject>();

    void Start()
    {
        StartCoroutine(SpawnGrid());
    }

    IEnumerator SpawnGrid()
    {
        // Calculate the offset to center the grid at (0, 0)
        float offsetX = (gridX - 1f) * tileSize / 2f;
        float offsetZ = (gridZ - 1f) * tileSize / 2f;

        for (int x = 0; x < gridX; x++)
        {
            for (int z = 0; z < gridZ; z++)
            {
                // Instantiate tile with the calculated offset
                Vector3 tilePosition = new Vector3(x * tileSize - offsetX, -30, z * tileSize - offsetZ);
                GameObject tile = Instantiate(tilePrefab, tilePosition, Quaternion.Euler(new Vector3(-90f, 0f, 0f)), transform);
                tiles.Add(tile);

                Renderer tileRenderer = tile.GetComponent<Renderer>();
                tileRenderer.material.color = colorGradient.Evaluate(0f);

                // Offset tiles in a circular pattern
                float distFromCenter = Vector2.Distance(new Vector2(x * tileSize, z * tileSize), new Vector2(offsetX, offsetZ));
                StartCoroutine(FloatingTile(tile, distFromCenter));
            }
        }

        yield return null;
    }

    IEnumerator FloatingTile(GameObject tile, float delay)
    {
        float elapsedTime = 0f;

        // Wait for the tile to start based on distance (circular pattern effect)
        yield return new WaitForSeconds(delay / spawnRadius);

        Vector3 startPosition = tile.transform.position;
        Vector3 targetPosition = new Vector3(startPosition.x, 0, startPosition.z);

        // Animate the tile floating upwards over time using the curve
        while (elapsedTime < animationTime)
        {
            float normalizedTime = elapsedTime / animationTime;
            float heightOffset = heightCurve.Evaluate(normalizedTime);

            tile.transform.position = Vector3.Lerp(startPosition, targetPosition, heightOffset);

            elapsedTime += Time.deltaTime;
            yield return null;
        }

        // Snap tile to final position
        tile.transform.position = targetPosition;

        // Once floating is done, start color change animation
        StartCoroutine(ChangeTileColor(tile));
    }

    IEnumerator ChangeTileColor(GameObject tile)
    {
        Renderer tileRenderer = tile.GetComponent<Renderer>();
        Color initialColor = colorGradient.Evaluate(0f);
        float colorChangeDuration = Random.Range(9f, 15f); // Random duration between 3-9 seconds

        float elapsedColorTime = 0f;
        while (true)
        {
            // Random color transition with offset and curve
            float curveTime = Mathf.PingPong(elapsedColorTime, colorChangeDuration) / colorChangeDuration;
            Color targetColor = colorGradient.Evaluate(curveTime);

            tileRenderer.material.color = Color.Lerp(initialColor, targetColor, curveTime);

            elapsedColorTime += Time.deltaTime;
            yield return null;
        }
    }
}

