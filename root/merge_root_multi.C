#include <string>
#include <iostream>

#include "TList.h"
#include "TFile.h"
#include "TTree.h"

// FILES MUST HAVE FORMAT prefix01.root or prefix001.root, etc.
// and must start from 1, not 0

// Change this line if your TTree has a different name
const char *TreeName = "data";

void merge_root_multi()
{
    using namespace std;

    int n_files;
    cout << "Number of files to merge: ";
    cin >> n_files;

    int zeroes = 0;
    int n_files_digit_test = n_files;
    while (n_files_digit_test /= 10) zeroes++;
    string leading_zeroes;
    for(int i = 0; i < zeroes; i++){
        leading_zeroes = leading_zeroes + "0";
    }

    // TODO: Support leading zeros
    string prefix;
    /* cout << "File prefix (everything up to the number): "; */
    /* cin >> prefix; */
    cout << "Prefix of files: ";
    cin >> prefix;

    TList tree_list;

    Int_t total_events = 0;

    digit_check = 10;

    for(int i = 1; i <= n_files; i++){
        if(i == digit_check){
            leading_zeroes = leading_zeroes.substr(0,leading_zeroes.size()-1);
            digit_check = 10*digit_check;
        }
        std::string i_string;
        std::stringstream ss;
        ss << i;
        i_string = ss.str();
        std::string filename = prefix + leading_zeroes + ss.str() + ".root";
        TFile *f = new TFile(filename.c_str());

        TTree *tree = (TTree *)f->Get(TreeName);

        cout << "Adding file: " << filename << endl;
        tree_list.Add(tree);

        total_events += (Int_t )tree->GetEntries();
    }

    string outfile;
    cout << "Outfile name: ";
    cin >> outfile;

    cout << "Opening output file: " << outfile << endl;
    TFile output(outfile.c_str(), "RECREATE");

    cout << "Merging trees...patience..." << endl;
    TTree::MergeTrees(&tree_list);
    output.Write();
    output.Close();

    cout << "Total Events: " << total_events << endl;
}
