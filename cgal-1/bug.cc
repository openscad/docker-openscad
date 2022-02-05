#include <CGAL/Exact_predicates_exact_constructions_kernel.h>
#include <CGAL/Polygon_mesh_processing/triangulate_faces.h>
#include <CGAL/Surface_mesh.h>

int main() {
        CGAL::Surface_mesh<CGAL::Point_3<CGAL::Epeck>> mesh;
        CGAL::Polygon_mesh_processing::triangulate_faces(mesh);
}
