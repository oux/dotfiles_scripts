file_to_commit=$1
commit_to_squash=$(git log --oneline $file_to_commit |awk '{print $1;exit}')
git commit $file_to_commit --fixup=$commit_to_squash --no-edit
