$urls = @(
  '/admin',
  '/admin/home',
  '/admin/categories',
  '/admin/categories/create',
  '/admin/users',
  '/admin/users/create',
  '/admin/videos',
  '/admin/videos/create',
  '/admin/products',
  '/admin/products/create',
  '/admin/post/create',
  '/admin/api/vendors',
  '/',
  '/login',
  '/register',
  '/videos',
  '/videos/1',
  '/categories'
)

foreach ($u in $urls) {
  Write-Output "--- $u"
  try {
    $out = & curl.exe -i "http://localhost:8080$u" 2>$null
    $line = $out | Select-String -Pattern '^HTTP/' | Select-Object -First 1
    if ($line) { $line.Line } else { Write-Output 'No HTTP response line' }
  } catch {
    Write-Output "request failed: $_"
  }
}
