node(:page)    { 1 }
node(:total)   { 3 }
node(:records) { 3 }

node(:result) do
  yield
end
