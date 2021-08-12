#include "bgen.h"

using namespace std;
using namespace bgen;

int main(int argc, char *argv[])
{
    if (argc < 2) {
        cerr << "Usage: " << argv[0] << " path-to-bgen-file.\n";
        exit(EXIT_FAILURE);
    }
    string fin(argv[1]);
    Bgen bg(fin, "", true);
    Variant v;
    float* dosages;
    while (true) {
        try {
            v = bg.next_var();
            dosages = v.minor_allele_dosage();
            for (uint i = 0; i < v.n_samples; i++)
            {
                cout << dosages[i] << " ";
            }
            cout << "\n";
        } catch (const std::out_of_range & e) {
            break;
        }
    }
    return 0;
}
