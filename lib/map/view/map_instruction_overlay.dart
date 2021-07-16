part of 'map_screen.dart';

class _MapInstructionOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final directions =
        context.select((DestinationCubit cubit) => cubit.state.directions);

    if (directions == null) {
      return SizedBox();
    }

    return Positioned(
      top: 20,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FractionallySizedBox(
        alignment: Alignment.topCenter,
        widthFactor: 1,
        heightFactor: .3,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6,
              )
            ],
          ),
          child: _content(directions),
        ),
      ),
    );
  }

  Widget _content(Directions directions) {
    final htmlInst = directions.htmlInstructions;
    return ListView.builder(
      itemCount: htmlInst.length,
      itemBuilder: (context, index) {
        return Html(data: htmlInst[index]);
      },
    );
  }
}
