using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public List<Transform> players;   // List of players to follow
    public Vector3 offset;            // Offset from the center point
    public float smoothSpeed = 0.125f; // Smooth factor for camera movement

    private Vector3 velocity = Vector3.zero;
    private Vector3 centerPoint;
    private Vector3 desiredPosition;

    void LateUpdate()
    {
        if (players.Count == 0)
            return;

        // Calculate the center point between all players
        centerPoint = GetCenterPoint();

        // Calculate the desired position (center point + offset)
        desiredPosition = centerPoint + offset;

        // Smoothly move the camera to the desired position
        transform.position = Vector3.SmoothDamp(transform.position, desiredPosition, ref velocity, smoothSpeed);
    }

    Vector3 GetCenterPoint()
    {
        if (players.Count == 1)
        {
            // If only one player, return their position
            return players[0].position;
        }

        // Otherwise, calculate the bounds that contain all players
        var bounds = new Bounds(players[0].position, Vector3.zero);
        for (int i = 1; i < players.Count; i++)
        {
            bounds.Encapsulate(players[i].position);
        }

        // Return the center of the bounds
        return bounds.center;
    }
}