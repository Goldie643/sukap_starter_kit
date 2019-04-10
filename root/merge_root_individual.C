#include <string>
#include <iostream>

#include "TList.h"
#include "TFile.h"
#include "TTree.h"

// Change this line if your TTree has a different name
const char *TreeName = "data";

void merge_root_individual()
{
    using namespace std;

    string outfile;
    cout << "Outfile name: ";
    cin >> outfile;

    TList tree_list;
    std::string filename;

    Int_t total_events = 0;

    cout << "Input name of file to merge: ";
    while(cin >> filename) {
        TFile *f = new TFile(filename.c_str());

        if(TTree *tree = (TTree *)f->Get(TreeName)) {

            cout << "Adding file: " << filename << endl;
            tree_list.Add(tree);

            total_events += (Int_t )tree->GetEntries();

        } else {
            cout << "File has no TTree named TMBTree" << endl;
        }
    }

    cout << "Opening output file: " << outfile << endl;
    TFile output(outfile.c_str(), "RECREATE");

    cout << "Merging trees...patience..." << endl;
    TTree::MergeTrees(&tree_list);
    output.Write();
    output.Close();

    cout << "Total Events: " << total_events << endl;
}
