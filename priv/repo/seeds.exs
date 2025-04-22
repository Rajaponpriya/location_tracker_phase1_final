alias LocationTracker.Repo
alias LocationTracker.Sites.Site

Repo.delete_all(Site)

now = DateTime.utc_now() |> DateTime.truncate(:second)

Repo.insert_all(Site, [
  %{
    name: "New York",
    latitude: 40.7128,
    longitude: -74.0060,
    inserted_at: now,
    updated_at: now
  },
  %{
    name: "London",
    latitude: 51.5074,
    longitude: -0.1278,
    inserted_at: now,
    updated_at: now
  },
  %{
    name: "Tokyo",
    latitude: 35.6762,
    longitude: 139.6503,
    inserted_at: now,
    updated_at: now
  },
  %{
    name: "Sydney",
    latitude: -33.8688,
    longitude: 151.2093,
    inserted_at: now,
    updated_at: now
  },
  %{
    name: "Rio de Janeiro",
    latitude: -22.9068,
    longitude: -43.1729,
    inserted_at: now,
    updated_at: now
  }
])
